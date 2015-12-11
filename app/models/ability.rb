class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, User
    end

    can :resolve, PullRequest do |pull_request|
      pull_request.reviewer == user
    end

    can :take, PullRequest do |pull_request|
      pull_request.reviewer.nil?
    end
  end
end
