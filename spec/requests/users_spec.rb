require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    before do
      @users = FactoryBot.create_list(:user, 3)
      get "/users"
    end

    it "リクエストに成功する" do
      expect(response).to have_http_status(:success)
    end

    it "ユーザ(nameとemail)の一覧が取得できる" do
      json = JSON.parse(response.body)
      
      expect(json).to eq @users.as_json(only: [:user_name, :email])
    end
  end

  describe "POST /users" do
    before do
      @user_params = FactoryBot.attributes_for(:user)
      
      post "/users", params: {user: @user_params}
    end
    
    it "リクエストに成功する" do
      expect(response).to have_http_status(:success)
    end
    
    it "ユーザが作成される" do
      user = User.find_by(email: @user_params[:email])
      
      expect(user).to be_present
    end
  end

  describe "GET /users/:id" do
    #TODO: サインイン済みの際のテストを書く。
    # 現状、rspecでsessionを扱う方法がわからないので、signinをmockできない
    pending "サインイン済み" do
      before do
        @user = FactoryBot.create(:user)
        signin(@user.email, @user.password)
        get "/users/#{@user[:id]}"
      end
      
      it "リクエストに成功する" do
        expect(response).to have_http_status(:success)
      end

      it "ユーザ(nameとemail)が取得できる" do
        json = JSON.parse(response.body)
        
        expect(json).to eq @user.as_json(only: [:user_name, :email])
      end
    end

    context "未サインイン" do
      before do
        @user = FactoryBot.create(:user)
        get "/users/#{@user[:id]}"
      end
      
      it "リクエストに失敗する" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
