class SessionsController < ApplicationController
    def create
        if signin(session_params[:email], session_params[:password])
            result = @user.info
            render json: { user: result }, status: :ok
        else
            render json: { errors: ["Invalid email or password"] }, status: :unauthorized
        end
    end

    private

    def session_params
        params.require(:session).permit(:email, :password)
    end

    def signin(email, password)
        @user = User.find_by(email: email)
        
        if @user && @user.authenticate(password)
            session[:user_id] = @user.id
            true
        else
            false
        end
    end
end
