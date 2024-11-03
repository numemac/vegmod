# Top karma is a textarea widget that displays the top 10 members
# ordered by score_30d descending.
# Title: Top Karma (30 days)
def configure_top_karma(subreddit)
  short_name = "Top Karma (30 days)"
  widget_kind = "textarea"
  widget = subreddit.widgets.find_by(kind: widget_kind, short_name: short_name)

  widget_text_lines = []

  Reddit::SubredditRedditor.where(
    subreddit: subreddit
  ).where.not(
    redditor: nil
  ).order(
    score_30d: :desc
  ).limit(10).each_with_index do |subreddit_redditor, index|
    widget_text_lines << "#{index + 1}. #{subreddit_redditor.redditor.name} - #{subreddit_redditor.score_30d}"
  end

  widget_text = widget_text_lines.join("  \n")

  if widget
    if widget.text_area.text != widget_text
      subreddit.praw.widgets_mod_update_text_area(widget.external_id, short_name, widget_text)
      return
    else
      # no changes
      return
    end
  else
    subreddit.praw.widgets_mod_add_text_area(short_name, widget_text)
    return
  end
end

def configure_community_list(subreddit)
  widget = subreddit.widgets.find_by(kind: "community-list")
  short_name = "Vegan Safe Spaces"
  return if widget && widget.short_name == short_name

  communities = Reddit::Subreddit.order(subscribers: :desc).where.not(id: subreddit.id).limit(5).map(&:display_name)
  subreddit.praw.widgets_mod_add_community_list(short_name, "", communities)
end

def configure_image_widgets(subreddit)
  widget_ids = []

  submissions = Reddit::SidebarVote.top(subreddit, "image", 5)
  image_widgets = Reddit::ImageWidget.where(widget_id: subreddit.widgets.where(kind: "image").pluck(:id))

  # stop measure - if there are more than 20 image widgets then something is wrong
  if image_widgets.count > 20
    raise "There are more than 20 image widgets for #{subreddit.display_name}"
  end
  
  images = image_widgets.map(&:images).flatten

  images_without_submissions = images.reject { |image| submissions.map(&:id).include?(image.submission_id) }
  submissions_without_images = submissions.reject { |submission| images.map(&:submission_id).include?(submission.id) }

  deleted_image_widgets = []
  for image in images_without_submissions
    next if deleted_image_widgets.include?(image.widget.external_id)

    subreddit.praw.widgets_sidebar_delete_widget(image.widget.external_id)
    deleted_image_widgets << image.widget.external_id
  end

  for submission in submissions_without_images
    # truncate submission title to 30 with ...
    shortname = submission.title.truncate(30, omission: "...")
    subreddit.praw.widgets_mod_add_image_widget(shortname, submission.url, submission.external_url)
  end
end

def order_widgets(subreddit)
  # Instructions:
  # - subreddit-rules is always first
  # - after subreddit-rules, image widgets are added in-between other widgets
  # - non-image widgets have a priority order
  # - image widgets are ordered by their created_at date
  # - if there are more images than in-between spaces,
  # - - the remaining images are added to the end
  #
  # EXAMPLE ORDER:
  # 1. subreddit-rules
  # 2. image
  # 3. community-list
  # 4. image
  # 3. textarea
  # 4. image
  # 5. button
  # 6. image
  # 7. image

  widgets = subreddit.widgets.order(order: :asc)
  Rails.logger.info "starting widgets=#{widgets.pluck(:external_id)} for #{subreddit.display_name}"

  new_order = []

  rules_widgets = widgets.select { |widget| widget.kind == "subreddit-rules" }
  image_widgets = widgets.select { |widget| widget.kind == "image" }

  # sort the image_widgets by id descending, so the newest images are first
  image_widgets = image_widgets.sort_by { |widget| widget.id }.reverse

  other_widgets = widgets - image_widgets - rules_widgets

  # for the sake of stability, handle cases
  # with none or multiple subreddit-rules widgets
  rules_widgets.each do |widget|
    new_order << widget.external_id
  end

  kind_order = ["textarea", "button", "community-list"]
  other_widgets = other_widgets.sort {
    |a, b| kind_order.index(a.kind) <=> kind_order.index(b.kind)
  }

  # because the zip function would put the first image after the first widget
  # we add it to the new order first
  new_order << image_widgets.shift.external_id if image_widgets.any?

  other_widgets.each do |widget|
    new_order << widget.external_id
    new_order << image_widgets.shift.external_id if image_widgets.any?
  end

  # add the remaining image widgets
  image_widgets.each do |widget|
    new_order << widget.external_id
  end

  # stop if the new order is the same as the old order
  # each widget has an 'order' field with the old order
  return if new_order == widgets.order(:order).pluck(:external_id)

  Rails.logger.info "Sending new_order=#{new_order} to #{subreddit.display_name}"

  subreddit.praw.widgets_mod_reorder(new_order)
end

# image_submissions = Reddit::SidebarVote.top(Reddit::Subreddit.find(1), "image", 5)
def configure_sidebar(subreddit)
  Rails.logger.info "Configuring sidebar for #{subreddit.display_name}"

  # run this before adding new widgets
  # new widgets will only be observable in the database
  # after another round of ingress
  order_widgets(subreddit)

  configure_community_list(subreddit)
  configure_image_widgets(subreddit)
  configure_top_karma(subreddit)

  # link_submissions = Reddit::SidebarVote.top(subreddit, "link", 5)
  # self_submissions = Reddit::SidebarVote.top(subreddit, "self", 5)


end

namespace :sidebar do

  task configure: :environment do
    subreddits = ["animalhaters", "circlesnip", "vegancirclejerk", "vegancirclejerkchat"]
    for subreddit in subreddits
      configure_sidebar(Reddit::Subreddit.find_by(display_name: subreddit))
    end
  end

end
