require 'rails_helper'

RSpec.describe "Test::Tests", type: :request do
  describe "GET /ping" do
    it "pongを返す" do
      get "/test/ping"
      message = response.parsed_body["message"]
      expect(message).to eq("pong")
    end
  end

  describe "GET /ping_with_message" do
    message = "pong"
    it "ping!<message>!を返す" do
      get "/test/ping_with_message", params: { message: message }
      result_message = response.parsed_body["message"]
      expect(result_message).to eq("ping!#{message}!")
    end
  end

  describe "GET /greet" do
    name = "test"
    it "Hello <name>!を返す" do
      post "/test/greet", params: { name: name }
      result_message = response.parsed_body["message"]
      expect(result_message).to eq("Hello #{name}!")
    end
  end
end
