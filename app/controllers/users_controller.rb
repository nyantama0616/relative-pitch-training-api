class UsersController < ApplicationController
    # before_action :singed_in_check, only: [:show]

    def index
        users = User.all
        result = users.map(&:info)
        
        render json: { users: result }
    end

    def show
        user = User.find_by(id: params[:id])
        result = user.as_json(only: [:user_name, :email, :image_path])

        if user
            render json: result
        else
            render json: { error: 'User not found' }, status: :not_found
        end
    end

    def create
        user = User.new(user_params)
        
        if user.save
            render json: user, status: :created
        else
            render json: user.errors, status: :unprocessable_entity
        end
    end

    private

    def user_params
        {
            user_name: params[:userName],
            email: params[:email],
            password: params[:password]
        }
    end
end
