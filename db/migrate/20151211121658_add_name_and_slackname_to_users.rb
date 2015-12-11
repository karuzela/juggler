class AddNameAndSlacknameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, null: false, default: ""
    add_column :users, :slack_username, :string, null: true
  end
end
