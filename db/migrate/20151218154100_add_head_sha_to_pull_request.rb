class AddHeadShaToPullRequest < ActiveRecord::Migration
  def change
    add_column :pull_requests, :head_sha, :string
  end
end
