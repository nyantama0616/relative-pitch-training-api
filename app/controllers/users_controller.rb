class UsersController < ApplicationController
    def index
        users = User.all
        result = users.as_json(only: [:name, :email])
        
        render json: result
    end

    def show
        user = User.find_by(id: params[:id])
        result = user.as_json(only: [:name, :email])

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
        params.require(:user).permit(:name, :email, :password).merge(password: params[:password]) #OPTIMIZE: mergeしないとpasswordがnilになるの何で？
    end
end
