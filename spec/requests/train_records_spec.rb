require 'rails_helper'

RSpec.describe "TrainRecords", type: :request do
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

  describe "GET /train_records/:id/means" do
    before do
      @train = FactoryBot.create(:train_record5)
      get "/train_records/#{@train[:id]}/means"
    end

    it "200が返ってくる" do
      expect(response).to have_http_status(200)
    end

    it "レスポンス形式が正しい" do
      expected = ["reactionTime", "missCount"].sort
      expect(response.parsed_body["means"].keys.sort).to eq expected
    end
  end
end
