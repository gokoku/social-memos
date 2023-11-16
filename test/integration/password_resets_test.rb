require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password reset" do
    get new_password_reset_url
    assert_template 'password_resets/new'

    # メアドが invalid
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'

    # メアドが valid
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url

    # パスワードの設定フォームのテスト
    user = assigns(:user)
    # メアドが無効
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    user.update_attribute(:activated, true)

    # メアドが有効で、トークンが無効
    get edit_password_reset_path("wrong token", email: user.email)
    assert_redirected_to root_url

    # メアド、トークン、有効
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email

    # 無効なパスワードとパスワードの確認
    patch password_reset_path(user.reset_token), params: { email: user.email,
                                                            user: { password: "foobar",
                                                                    password_confirmation: "fooquux" } }
    assert_select 'div#error_explanation'

    # パスワードが空
    patch password_reset_path(user.reset_token), params: { email: user.email,
                                                            user: { password: "",
                                                                    password_confirmation: "" } }
    assert_select 'div#error_explanation'

    # 有効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token), params: { email: user.email,
                                                            user: { password: "foobar",
                                                                    password_confirmation: "foobar" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path, params: { password_reset: { email: @user.email } }
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path( @user.reset_token ), params: { email: @user.email,
                                                              user: { password: "foobar",
                                                                      password_confirmation: "foobar" } }
    assert_response :redirect
    follow_redirect!
    assert_match /Password reset has expired./i, response.body
  end

  test "password resets" do
    @user.reload
    assert_nil @user.reset_digest
  end

end
