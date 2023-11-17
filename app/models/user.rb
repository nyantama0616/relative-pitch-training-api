class User < ApplicationRecord
    has_secure_password
    validates :email, uniqueness: { message: "Email has already been taken" }
end
