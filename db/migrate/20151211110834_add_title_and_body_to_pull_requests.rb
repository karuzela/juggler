class AddTitleAndBodyToPullRequests < ActiveRecord::Migration
  def change
    add_column :pull_requests, :title, :string, null: false
    add_column :pull_requests, :body, :text, null: false
  end
end
