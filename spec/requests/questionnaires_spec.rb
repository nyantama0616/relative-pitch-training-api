require 'rails_helper'

RSpec.describe "Questionnaires", type: :request do
  describe "GET /questionnaires/:name" do
    before do
      # name = "attribute"
      # name = "interest"
      name = "self_efficacy"
      get "/questionnaires/#{name}"
    end

    it "200が返ってくる" do
      expect(response).to have_http_status(200)
    end

    it "返り値が「questionnaire(配列)」であること" do
      questionnaire = response.parsed_body["questionnaire"]
      expect(questionnaire).to be_an_instance_of(Array)
    end

    it "keyが適切な値になっている" do
      expected_keys = ["id", "content", "answer", "maxSelectNum", "remarks"].sort
      keys = response.parsed_body["questionnaire"].first.keys.sort
      expect(keys).to eq expected_keys
    end
  end

  describe "POST /questionnaires/" do
    before do
      user = FactoryBot.create(:user)
      data = [
        {
          "id" => 1,
          "content" => "test",
          "answer" => "answer",
          "maxSelectNum" => 1,
          "remarks" => "remarks"
        }
      ]
      post "/questionnaires", params: { questionnaireName: "attribute", data: data, userId: user.id }
    end

    after do
      question = Questionnaire.first
      question.destroy
    end

    it "201が返ってくる" do
      expect(response).to have_http_status(201)
    end

    it "storage/questionnaires/:idが作成される" do
      user = User.first
      question = Questionnaire.first
      file_path = "storage/#{Rails.env}/questionnaire/#{question.data_file_path}.csv" #TODO: ディレクトリしか見てないけど
      expect(File.exist?(file_path)).to eq true
    end
  end
end
