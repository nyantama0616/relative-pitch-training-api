class ApplicationController < ActionController::API
    
    protected

    def current_user
        logger.debug("session[:user_id]hellohel: #{session[:user_id]}")
        @current_user ||= User.find_by(id: session[:user_id])
    end

    def signed_in?
        !!@current_user
    end
end
