class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_access!

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(create_params)

    if @user.save
      redirect_to users_path
    else
      render action: 'new'
    end
  end

  def github_connect
    if ConnectWithGithubService.new(current_user, params[:code]).call.nil?
      redirect_to root_path, alert: 'There was an error while connecting to Github. Account not connected.'
    else
      redirect_to root_path, notice: 'Your account was successfully connected'
    end
  end

  private

  def verify_access!
    authorize!(:manage, User)
  end

  private

  def create_params
    params[:user].permit(:name, :slack_username, :email, :password, :password_confirmation)
  end
end
