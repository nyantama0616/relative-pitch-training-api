class User < ApplicationRecord
	include UserAnalysis
	
	has_secure_password
	validates :email, uniqueness: { message: "Email has already been taken" }
	has_many :train_records, dependent: :destroy
	has_many :questionnaire, dependent: :destroy

	def info
			json = as_json(only: [:id, :user_name, :email, :image_path])
			json.deep_transform_keys! { |key| key.camelize(:lower) }
			json
	end
end
