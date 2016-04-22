class UsersController < ApplicationController

  before_action :authenticate?, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:show, :followings, :followers]

  def show
    @microposts = @user.microposts.order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    @micropost = current_user.microposts.find_by(id: params[:id])
    return redirect_to root_url if @micropost.nil?
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  def followings
    @msg = 'Following'
    @follows = @user.following_users
    render 'follows'
  end

  def followers
    @msg = 'Follower'
    @follows = @user.follower_users
    render 'follows'
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Update user information!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :area, :password,
                                 :password_confirmation)
  end

  def authenticate?
    @user = User.find(params[:id])
    if @user != current_user
      flash[:warning] = "Not authenticate"
      redirect_to root_path
    end
  end
end
