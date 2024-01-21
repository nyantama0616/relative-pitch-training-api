class RemoveDataFilePathFromQuestionnaires < ActiveRecord::Migration[7.0]
  def change
    remove_column :questionnaires, :data_file_path
  end
end
