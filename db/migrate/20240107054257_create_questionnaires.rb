class CreateQuestionnaires < ActiveRecord::Migration[7.0]
  def change
    create_table :questionnaires do |t|
      t.string :name, null: false
      t.text :data_file_path, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
