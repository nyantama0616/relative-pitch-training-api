require 'rails_helper'

RSpec.describe "Images", type: :request do
  describe "GET /index" do
    image_path = "panda.jpg"
    
    before do
      get "/images/#{image_path}"
    end

    it "リクエストが成功するか" do
      expect(response).to have_http_status(:success)
    end

    it "画像が取得できるか" do
      expect(response.body).to eq File.binread(Rails.root.join('public', 'images', image_path))
    end
  end
end
