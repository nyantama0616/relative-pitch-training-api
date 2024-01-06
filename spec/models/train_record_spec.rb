require 'rails_helper'

RSpec.describe TrainRecord, type: :model do
  describe 'validations' do
    before do
      @train_record = FactoryBot.build(:train_record)
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

    describe "jsonの形式が不正だと保存できない" do
      it "case1" do
        @train_record.questions = "invalid json"
        @train_record.valid?
        expect(@train_record.errors[:json]).to include("invalid json")
      end
    end
  end
end
