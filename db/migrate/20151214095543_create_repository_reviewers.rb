class CreateRepositoryReviewers < ActiveRecord::Migration
  def change
    create_table :repository_reviewers do |t|
      t.integer :user_id
      t.integer :repository_id

      t.timestamps null: false
    end
  end
end
