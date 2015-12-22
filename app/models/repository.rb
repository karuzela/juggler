class Repository < ActiveRecord::Base
  has_many :pull_requests, dependent: :destroy
  has_many :repository_reviewers, dependent: :destroy
  has_many :authorized_reviewers, through: :repository_reviewers, source: :user

  validates_presence_of :full_name

  def self.subscribed_events
    [
      'pull_request',
      'issue_comment'
    ]
  end
end
