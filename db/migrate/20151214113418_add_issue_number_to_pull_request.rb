class AddIssueNumberToPullRequest < ActiveRecord::Migration
  def change
    add_column :pull_requests, :issue_number, :integer
  end
end
