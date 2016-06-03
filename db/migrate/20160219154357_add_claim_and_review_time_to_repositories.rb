class AddClaimAndReviewTimeToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :claim_time, :integer, default: 3
    add_column :repositories, :remind_time, :integer, default: 3
  end
end
