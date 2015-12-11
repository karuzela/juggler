class PullRequest < ActiveRecord::Base
  belongs_to :repository
  belongs_to :author, foreign_key: "author_id", class_name: "User"
  belongs_to :reviewer, foreign_key: "reviewer_id", class_name: "User"
end
