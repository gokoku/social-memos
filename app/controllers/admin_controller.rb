class AdminController < ApplicationController
  before_action :correct_admin_user, only: [:index]

  def index
    @users = User.all.paginate(page: params[:page], per_page: 12)
  end

  private
  def correct_admin_user
    @user = current_user
    if @user && @user.admin?
      return true
    end
    redirect_to(root_url)
  end
end
