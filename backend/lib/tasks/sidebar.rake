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

# image_submissions = Reddit::SidebarVote.top(Reddit::Subreddit.find(1), "image", 5)
def configure_sidebar(subreddit)
  Rails.logger.info "Configuring sidebar for #{subreddit.display_name}"

  configure_community_list(subreddit)
  configure_image_widgets(subreddit)

  # link_submissions = Reddit::SidebarVote.top(subreddit, "link", 5)
  # self_submissions = Reddit::SidebarVote.top(subreddit, "self", 5)
end

namespace :sidebar do

  task configure: :environment do
    # subreddits = ["animalhaters", "circlesnip", "vegancirclejerk", "vegancirclejerkchat"]
    subreddits = ["animalhaters", "circlesnip", "vegancirclejerk", "vegancirclejerkchat"]
    for subreddit in subreddits
      configure_sidebar(Reddit::Subreddit.find_by(display_name: subreddit))
    end
  end

end
