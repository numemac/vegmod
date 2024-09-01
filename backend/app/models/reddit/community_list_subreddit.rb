class Reddit::CommunityListSubreddit < RedditRecord
  belongs_to :community_list, class_name: Reddit::CommunityList.name
  belongs_to :community, foreign_key: :subreddit_id, class_name: Reddit::Subreddit.name
end