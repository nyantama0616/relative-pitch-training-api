class AddSubnameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :subname, :string
  end
end
