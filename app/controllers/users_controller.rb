class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers]
  before_action :find_user, only: [:show, :followings, :followers, :likes]
  
  def index
    @pagy, @users = pagy(User.order(id: :desc), items: 25)
  end

  def show
    @pagy, @microposts = pagy(@user.microposts.order(id: :desc))
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = 'ユーザを登録しました'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました'
      render :new
    end
  end
  
  def followings
    @pagy, @followings = pagy(@user.followings)
    counts(@user)
  end
  
  def followers
    @pagy, @followers = pagy(@user.followers)
    counts(@user)
  end
  
  def likes
    @pagy, @favorites = pagy(@user.favorite_microposts)
    counts(@user)
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def find_user
    @user = User.find(params[:id])
  end
  
  def counts(user)
    @count_microposts = user.microposts.count
    @count_followings = user.followings.count
    @count_followers = user.followers.count
    @count_favorites = user.favorite_microposts.count
  end
end
