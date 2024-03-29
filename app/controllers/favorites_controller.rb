class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.favorite(micropost)
    @pagy, @favorites = pagy(current_user.favorites)
    flash[:success] = '投稿をお気に入り登録しました'
    redirect_back(fallback_location: root_path)
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.unfavorite(micropost)
    @pagy, @favorites = pagy(current_user.favorites)
    flash[:success] = 'お気に入りを解除しました'
    redirect_back(fallback_location: root_path)
  end
end
