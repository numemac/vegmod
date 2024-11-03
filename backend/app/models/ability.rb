class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the user here. For example:
    #
    #   return unless user.present?
    #   can :read, :all
    #   return unless user.admin?
    #   can :manage, :all
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

    # additional permissions for logged in users (they can read their own posts)
    return unless user.present?

    # only if the user is the user being read
    can :read, User, id: user.id

    RedditRecord.descendants.each do |klass|
      can :read, klass
    end

    can :read, Plugin
    can :read, Metrics::Metric
    can :read, Metrics::MetricSubject
    can :read, Metrics::MetricSubjectDataPoint

    can [:update], User, id: user.id

    can [:create, :update, :destroy], Reddit::Subreddit do |subreddit|
      subreddit.users.include?(user)
    end

    can [:create, :update, :destroy], Reddit::SubredditPlugin do |subreddit_plugin|
      subreddit_plugin.subreddit.users.include?(user)
    end

  end
end