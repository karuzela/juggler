class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user].permit(:email, :password, :password_confirmation))

    if @user.save
      redirect_to users_path
    else
      render action: 'new'
    end
  end
end
