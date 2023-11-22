require "test_helper"

class AdminLoginTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:michael)
    @user = users(:archer)
    @other_user = users(:lana)
  end

  test "no login user not asign admin page" do
    get admin_index_url
    assert_redirected_to root_url
  end

  test "no admin not asign admin page" do
    log_in_as(@user)
    get admin_index_url
    assert_redirected_to root_path
  end

  test "admin can asign admin page" do
    log_in_as(@admin_user)
    get admin_index_url
    assert_template 'admin/index'
  end

  test "no admin can't delete user" do
    log_in_as(@user)
    assert_no_difference 'User.count'do
      delete user_path(@other_user)
    end
    assert_redirected_to root_url
  end

  test "admin can delete user" do
    log_in_as(@admin_user)
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
    assert_redirected_to admin_index_url

    # 自分自身は削除出来ないようにしよう
    assert_no_difference 'User.count' do
      delete user_path(@admin_user)
    end
    assert_redirected_to admin_index_url
  end
end
