require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "POST /signin" do
    context "パラメータが正しい場合" do
      before do
        @user = FactoryBot.create(:user)
        post "/signin", params: { session: { email: @user.email, password: @user.password } }
      end
  
      it "リクエストが成功するか" do
        expect(response).to have_http_status(:success)
      end
  
      it "ログインできてるか" do
        expect(signed_in?).to be_truthy
      end

      it "ユーザ(id, userName, email, imagePath)が取得できる" do
        user = JSON.parse(response.body)["user"]
        keys = ["id", "userName", "email", "imagePath"].sort
        
        expect(user.keys.sort).to eq(keys)
      end
    end

    context "パラメータが正しくない場合" do
      before do
        @user = FactoryBot.create(:user)
        password = @user.password + "invalid"
        post "/signin", params: { session: { email: @user.email, password: password } }
      end

      it "リクエストが失敗するか" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
