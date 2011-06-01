class UsersController < ApplicationController
  include UsersHelper
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  def new
    @title = "Sign Up"
    @user  = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      sign_in @user
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end
  
  def edit
    @user  = User.find(params[:id])
    @title = "Edit user"
  end
  
  def update
    @user  = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => {:success => "You successfully updated your data!"}
    else
      @title = "Edit user"
      render 'edit'
    end
  end

    def destroy
      @user.destroy
      # flash[:success] = "User annihilated"
      redirect_to users_path, :flash => { :success => "User annihilated." }
    end
  
  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user? (@user)
  end
  
  def admin_user
    @user = User.find(params[:id])
    # redirect_to(root_path) unless (current_user.admin? && !current_user?(user))
    redirect_to(root_path) if !current_user.admin? || current_user?(@user)
  end
  
end
