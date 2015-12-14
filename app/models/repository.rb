class Repository < ActiveRecord::Base
  has_many :repository_reviewers
  has_many :authorized_reviewers, through: :repository_reviewers, source: :user
end
