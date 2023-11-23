module SigninSupport  
  def signin(email, password)
    #TODO: sessionにuse_idをセットできない。。。
  end

  def signed_in?    
    !!session[:user_id]
  end
end

RSpec.configure do |config|
  config.include SigninSupport
end
