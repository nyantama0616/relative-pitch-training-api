require 'rails_helper'

RSpec.describe "TrainRecords", type: :request do
  describe "GET /interval_rates" do
    it "返り値が「missRates(12個の配列)とaverageReactionRates(12個の配列)のハッシュ」であること" do
      train_record = FactoryBot.create(:train_record)
      get "/interval_rates", params: {id: train_record.id}
      json = JSON.parse(response.body)["intervalRates"]
      flag = json["missRates"].length == 12 && json["averageReactionRates"].length == 12
      expect(flag).to be_truthy
    end
  end
end
