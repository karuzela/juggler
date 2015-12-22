class ChangeFullNameInRepository < ActiveRecord::Migration
  def change
    change_column :repositories, :full_name, :string, required: true
  end
end
