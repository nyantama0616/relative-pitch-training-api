require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it "is invalid with a duplicate email address" do
      user0 = FactoryBot.create(:user)
      user1 = FactoryBot.build(:user, email: user0.email)
      expect(user1).to_not be_valid
    end
  end
end
