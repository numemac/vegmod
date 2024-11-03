class User < FetchRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :lockable, :trackable

  has_many :user_subreddits, class_name: UserSubreddit.name, dependent: :destroy
  has_many :subreddits, through: :user_subreddits, class_name: Reddit::Subreddit.name

  has_many :user_redditors, class_name: UserRedditor.name, dependent: :destroy
  has_many :redditors, through: :user_redditors, class_name: Reddit::Redditor.name

  def name
    if redditors.length == 1
      return "u/#{ redditors.first.name }"
    end
    "[#{ redditors.map(&:name).map { |n| "u/#{n}" }.join(', ') }]"
  end

  def moderates?(subreddit)
    subreddits.include?(subreddit)
  end

  def self.always_include
    [
      :redditors,
      :subreddits
    ]
  end

  def self.computed_fields
    [
      :name
    ]
  end

end
