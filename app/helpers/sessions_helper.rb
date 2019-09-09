module SessionsHelper
    # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end
  
    # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end
  
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  
    def logged_in?
    !current_user.nil?
    end
      
    
      # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
      # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def adminuser
   @admin = User.create(name:  "admin",
             email: "admin",
             password:              "password",
             password_confirmation: "password",
             admin: true)
   @admin.save(:validate => false)
  end
  
  

    
    # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
  
end
