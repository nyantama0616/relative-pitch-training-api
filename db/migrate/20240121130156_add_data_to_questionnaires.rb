class AddDataToQuestionnaires < ActiveRecord::Migration[7.0]
  def change
    add_column :questionnaires, :data, :text, null: false
  end
end
