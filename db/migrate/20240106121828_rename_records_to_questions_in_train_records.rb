class RenameRecordsToQuestionsInTrainRecords < ActiveRecord::Migration[7.0]
  def change
    rename_column :train_records, :records, :questions
  end
end
