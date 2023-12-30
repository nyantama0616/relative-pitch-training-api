require 'rails_helper'

RSpec.describe User, type: :request do
  describe "GET /users" do
    before do
      FactoryBot.create_list(:user, 3)
      get "/users"
    end

    it "200が返ってくる" do
      expect(response).to have_http_status(200)
    end

    it "Userのリストが返ってくる" do
      users = JSON.parse(response.body)["users"]
      
      expect(users.length).to eq 3
    end

    it "id, email, userNameが含まれている" do
      users = JSON.parse(response.body)["users"]
      user = users[0]

      expect(user.keys.sort).to eq ["id", "userName", "email"].sort
    end
  end

  describe "POST /users" do
    before do
      @params = {
        userName: "test",
        email: "test@example.com",
        password: "password"
      }
      post "/users", params: @params
    end

    it "201が返ってくる" do
      
      binding.pry
      
      expect(response).to have_http_status(201)
    end

    it "Userが1つ作成される" do
      expect(User.count).to eq 1
    end
  end
end
