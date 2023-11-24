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

      it "ユーザ(name, email, image_path)が取得できる" do
        json = JSON.parse(response.body)
        
        expect(json).to eq @user.as_json(only: [:user_name, :email, :image_path])
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
