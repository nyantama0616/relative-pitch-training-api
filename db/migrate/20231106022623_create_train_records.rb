class CreateTrainRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :train_records do |t|
      t.text :records
      t.timestamps
    end
  end
end
