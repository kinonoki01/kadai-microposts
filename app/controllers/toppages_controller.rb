class ToppagesController < ApplicationController
  def index
    if logged_in?
      @micropost = current_user.microposts.build  # 投稿用
      @pagy, @microposts = pagy(current_user.microposts.order(id: :desc))
    end
  end
end
