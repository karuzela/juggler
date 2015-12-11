class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :git_url
      t.string :html_url
      t.string :owner
      t.boolean :synchronized, default: false

      t.timestamps null: false
    end
  end
end
