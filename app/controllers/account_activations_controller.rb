class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      flash[:success] = "アカウントがアクティベートされました。"
      render "valid"
    else
      flash[:danger] = "無効なアクティベーションリンクです。"
      render "invalid"
    end
  end
end
