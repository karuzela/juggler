class PullRequest < ActiveRecord::Base
  belongs_to :repository
  belongs_to :author, foreign_key: "author_id", class_name: "User"
  belongs_to :reviewer, foreign_key: "reviewer_id", class_name: "User"

  def pending?
    state == PullRequestState::PENDING
  end

  def accepted?
    state == PullRequestState::ACCEPTED
  end

  def rejected?
    state == PullRequestState::REJECTED
  end
end
