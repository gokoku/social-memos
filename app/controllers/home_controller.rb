class HomeController < ApplicationController
  def index
    # 全ユーザー通して最新の投稿順で取得する
    @microposts = Micropost.all.paginate(page: params[:page], per_page: 16)

    @micropost = current_user.microposts.build if logged_in?
  end

  def help
  end
end
