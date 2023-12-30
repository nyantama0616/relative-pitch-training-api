class User < ApplicationRecord
    has_secure_password
    validates :email, uniqueness: { message: "Email has already been taken" }
    has_many :train_records, dependent: :destroy

    def info
        json = as_json(only: [:id, :name, :email])
        json['userName'] = json.delete('name')
        json
    end
end
