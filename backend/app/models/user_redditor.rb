class UserRedditor < FetchRecord
  belongs_to :user, class_name: User.name
  belongs_to :redditor, class_name: Reddit::Redditor.name

  def self.always_include
    [
      :redditor
    ]
  end
end