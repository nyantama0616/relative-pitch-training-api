require 'rails_helper'

RSpec.describe TrainRecord, type: :model do
  describe 'create' do
    before do
      @user = FactoryBot.create(:user)
      @train_record = FactoryBot.build(:train_record, user_id: @user.id)
    end

    it "Factorybotによるcreateはできる" do
      res = @train_record.save
      expect(res).to be_truthy
    end

    it "user_idがないときは作成できない" do
      @train_record.user_id = nil
      @train_record.valid?
      expect(@train_record.errors[:user_id]).to include("can't be blank")
    end

  end
end
