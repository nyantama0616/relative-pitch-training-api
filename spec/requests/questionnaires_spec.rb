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
end
