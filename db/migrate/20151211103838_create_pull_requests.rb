class CreatePullRequests < ActiveRecord::Migration
  def change
    create_table :pull_requests do |t|
      t.integer :repository_id, null: false
      t.integer :author_id, null: true
      t.integer :reviewer_id, null: true

      t.string :state, null: false, default: "pending"

      t.datetime :opened_at, null: false
      t.datetime :assigned_at, null: true

      t.timestamps null: false
    end
  end
end
