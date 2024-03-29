class UsersController < ApplicationController
before_action :logged_in_user, only: [:edit, :update, :destroy, :index]
before_action :exist_user, only: [:edit, :update, :destroy, :show]
before_action :correct_user,   only: [:edit, :update]
before_action :admin_user,     only: [:destroy, :index]

  def show
    @user = User.find(params[:id])
    @items = @user.items.paginate(page: params[:page])
    @width = 33.33
  end

  def new
    if (logged_in?)
    flash[:danger]= 'You have already registered'
    redirect_to current_user
    else
    @user = User.new
    end
  end

  def create
    @user = User.create(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the EMALL!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end


  def index
    @users = User.paginate(page: params[:page])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
        # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
     if !(current_user?(@user))
      redirect_to(root_url) 
      flash[:danger] = "You don't have the permission!"
     end
    end
    
        # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
    def exist_user
    @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    if @user.nil?
    flash[:danger]= "User is not exist"
    redirect_to root_url
    end
    end
  

end