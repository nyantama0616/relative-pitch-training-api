require 'rails_helper'

RSpec.describe "TrainRecords", type: :request do
  describe "POST /train_records" do
    before do
      @user = FactoryBot.create(:user)
      @records = [
          {
            "note0" => "0",
            "note1" => "0",
            "missCount" => "0",
            "duration" => "0"
          },
          {
            "note0" => "0",
            "note1" => "1",
            "missCount" => "0",
            "duration" => "0"
          },
        ]
      
      post "/train_records", params: {records: @records, user_id: @user.id}
    end

    it "200が返ってくる" do
      expect(response).to have_http_status(200)
    end

    it "TrainRecordが1つ作成される" do
      expect(TrainRecord.count).to eq 1
    end

    it "TrainRecordのrecordsが正しい値になっている" do
      parsed = JSON.parse(TrainRecord.first.records)
      expect(parsed).to eq @records
    end

    it "TrainRecordのuser_idが正しい値になっている" do
      expect(TrainRecord.first.user_id).to eq @user.id
    end
  end

  describe "GET /interval_rates" do
    before do
      user = FactoryBot.create(:user)
      train_record = FactoryBot.create(:train_record, user_id: user.id)
      
      get "/interval_rates", params: {id: train_record.id}
    end

    it "返り値が「missRates(12個の配列)とaverageReactionRates(12個の配列)のハッシュ」であること" do
      json = JSON.parse(response.body)["intervalRates"]
      flag = json["missRates"].length == 12 && json["averageReactionRates"].length == 12
      expect(flag).to be_truthy
    end
  end
end
