class RenameIsShimamuraToShimamuraInUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :is_shimamura, :shimamura?
  end
end
