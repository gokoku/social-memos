class HomeController < ApplicationController
  def index
    # 全ユーザー通して最新の投稿順で取得する
    @microposts = Micropost.all.paginate(page: params[:page], per_page: 16)
  end

  def help
  end
end
