require 'rails_helper'

RSpec.describe "TrainRecords", type: :request do
  # describe "POST /train_records" do
  #   before do
  #     @user = FactoryBot.create(:user)
  #     @records = [
  #         {
  #           "note0" => "0",
  #           "note1" => "0",
  #           "missCount" => "0",
  #           "duration" => "0"
  #         },
  #         {
  #           "note0" => "0",
  #           "note1" => "1",
  #           "missCount" => "0",
  #           "duration" => "0"
  #         },
  #       ]
      
  #     post "/train_records", params: {records: @records, user_id: @user.id}
  #   end

  #   it "200が返ってくる" do
  #     expect(response).to have_http_status(200)
  #   end

  #   it "TrainRecordが1つ作成される" do
  #     expect(TrainRecord.count).to eq 1
  #   end

  #   it "TrainRecordのrecordsが正しい値になっている" do
  #     parsed = JSON.parse(TrainRecord.first.records)
  #     expect(parsed).to eq @records
  #   end

  #   it "TrainRecordのuser_idが正しい値になっている" do
  #     expect(TrainRecord.first.user_id).to eq @user.id
  #   end
  # end

  # describe "GET /interval_rates" do
  #   before do
  #     user = FactoryBot.create(:user)
  #     train_record = FactoryBot.create(:train_record, user_id: user.id)
      
  #     get "/interval_rates", params: {id: train_record.id}
  #   end

  #   it "返り値が「missRates(12個の配列)とaverageReactionRates(12個の配列)のハッシュ」であること" do
  #     json = JSON.parse(response.body)["intervalRates"]
  #     flag = json["missRates"].length == 12 && json["averageReactionRates"].length == 12
  #     expect(flag).to be_truthy
  #   end
  # end

  describe "GET /train_records/:id" do
    before do
      train_record = FactoryBot.create(:train_record)

      get "/train_records/#{train_record.id}"
      
      @record = response.parsed_body["record"]
    end

    it "200が返ってくる" do
      expect(response).to have_http_status(200)
    end

    it "TrainRecordのidが正しい値になっている" do
      expect(@record["id"]).to eq TrainRecord.first.id
    end

    it "TrainRecordのuser_idが正しい値になっている" do
      expect(@record["userId"]).to eq TrainRecord.first.user_id
    end

    it "TrainRecordのquestionsが正しい値になっている" do
      expected_questions = TrainRecord.parsed_questions(TrainRecord.first.questions)
      expect(@record["questions"]).to eq expected_questions
    end

    it "idが負の値の場合、最新のTrainRecordが返ってくる" do
      FactoryBot.create_list(:train_record, 3)
      last_record = TrainRecord.last
      
      get "/train_records/-1"
      
      record = response.parsed_body["record"]
      expect(record["id"]).to eq last_record.id
    end
  end

  describe "POST /train_records" do
    before do
      params = FactoryBot.build(:train_record).attributes
      params = {userId: params["user_id"], questions: TrainRecord.parsed_questions(params["questions"])}

      post "/train_records", params: params
    end

    it "201が返ってくる" do
      expect(response).to have_http_status(201)
    end

    it "TrainRecordが1つ作成される" do
      expect(TrainRecord.count).to eq 1
    end

    it "作成されたTrainRecordのidが返ってくる" do
      id = JSON.parse(response.body)["recordId"]
      record = TrainRecord.find(id)
      expect(record).to be_truthy
    end
  end
end
