require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it "重複したemailを登録できない" do
      user0 = FactoryBot.create(:user)
      user1 = FactoryBot.build(:user, email: user0.email)
      expect(user1).to_not be_valid
    end
  end

  describe 'associations' do
    it "userが削除されるとtrain_recordも削除される" do
      user = FactoryBot.create(:user)
      FactoryBot.create(:train_record, user: user)
      expect { user.destroy }.to change { TrainRecord.count }.by(-1)
    end

    it "train_recordのリストを取得できる" do
      user = FactoryBot.create(:user)
      FactoryBot.create_list(:train_record, 3, user: user)
      expect(user.train_records.count).to eq 3
    end
  end
end
