require 'rails_helper'

RSpec.describe "TrainRecords", type: :request do
  describe "GET /train_records" do
    before do
      @users = FactoryBot.create_list(:user, 3)
      10.times do |i|
        FactoryBot.create(:train_record, user_id: @users[i % 3].id)
      end
      
      get "/train_records", params: {user_id: @users[0].id}
    end

    it "200 OKが返ってくる" do
      expect(response).to have_http_status(:ok)
    end

    it "返り値が整数の配列である" do
      ids = JSON.parse(response.body)["train_record_ids"]
      
      expect(ids).to be_an_instance_of(Array)
      expect(ids.all?{|id| id.is_a?(Integer)}).to be_truthy
    end

    it "返り値がTrainRecord.where(user_id: @users[0].id).order(:created_at)の結果と一致する" do
      ids = JSON.parse(response.body)["train_record_ids"]
      expect(ids).to eq TrainRecord.where(user_id: @users[0].id).order(:created_at).pluck(:id)
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
