class RenameNameColumnInUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :name, :user_name
    change_column :users, :user_name, :string, default: "panda"
  end
end
