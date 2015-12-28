class PullRequest < ActiveRecord::Base
  belongs_to :repository
  belongs_to :author, foreign_key: "author_id", class_name: "User"
  belongs_to :reviewer, foreign_key: "reviewer_id", class_name: "User"

  before_create :set_token

  def pending?
    state == PullRequestState::PENDING
  end

  def accepted?
    state == PullRequestState::ACCEPTED
  end

  def rejected?
    state == PullRequestState::REJECTED
  end

  def merged?
    state == PullRequestState::MERGED
  end

  def closed?
    state = PullRequestState::CLOSED
  end

  def can_be_taken?
    pending? && reviewer.blank?
  end

  def can_be_reviewed?
    pending? || accepted? || rejected?
  end

  def set_token
    token = SecureRandom.hex(3)
    while self.class.where(token: token).present?
      token = SecureRandom.hex(3)
    end
    self.token = token
  end
end
