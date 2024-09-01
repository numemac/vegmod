class Reddit::CommunityList < RedditRecord
  belongs_to :widget, class_name: Reddit::Widget.name
  has_one :subreddit, through: :widget, class_name: Reddit::Subreddit.name

  has_many :community_list_subreddits, class_name: Reddit::CommunityListSubreddit.name, dependent: :destroy
  has_many :communities, through: :community_list_subreddits, class_name: Reddit::Subreddit.name

  def self.import(widget, data)
    return if data.nil?

    community_list = Reddit::CommunityList.find_by_widget_id(widget.id)
    community_list = Reddit::CommunityList.new if community_list.nil?

    community_list.widget = widget

    community_list.save! if community_list.changed?

    if data.key?("data")
      existing_community_list_subreddit_ids = community_list.communities.pluck(:id)
      import_community_list_subreddit_ids = []

      data["data"].each do |subreddit_external_id|
        community = Reddit::Subreddit.find_by_external_id(subreddit_external_id)
        next if community.nil?

        community_list_subreddit = Reddit::CommunityListSubreddit.find_by(
          community_list: community_list,
          community: community
        )

        if community_list_subreddit.nil?
          community_list_subreddit = Reddit::CommunityListSubreddit.new
          community_list_subreddit.community_list = community_list
          community_list_subreddit.community = community
          community_list_subreddit.save!
        end

        import_community_list_subreddit_ids << community_list_subreddit.id
      end

      # Delete communities that were not imported, must be resolved
      Reddit::CommunityListSubreddit.where(
        community_list: community_list,
        subreddit_id: (
          existing_community_list_subreddit_ids - import_community_list_subreddit_ids
        )
      ).destroy_all

      return community_list
    end
  end
end