class AddTokenToPullRequest < ActiveRecord::Migration
  def change
    add_column :pull_requests, :token, :string
    add_index :pull_requests, :token, unique: true
  end
end
