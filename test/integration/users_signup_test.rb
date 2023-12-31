require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                        email: "user@example.com",
                                        password: "password",
                                        password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?

    # activation してないでログイン
    log_in_as(user)
    assert_not is_logged_in?

    # activate token が invalid
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?

    # activate token が valid で mail が invalid
    get edit_account_activation_path(user.activation_token, email: "wrong")
    assert_not is_logged_in?
    assert_template 'account_activations/invalid'

    # activate token も email も valid
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert_not is_logged_in?
    assert_template 'account_activations/valid'
    assert_select "a[href=?]", login_path, count: 2
  end
end
