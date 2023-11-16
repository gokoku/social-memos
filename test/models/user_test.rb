require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                      password: "foobar", password_confirmation: "foobar")
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present(no blunk)' do
    @user.name = ""
    assert_not @user.valid?
  end

  test 'name should be present(no spaces)' do
    @user.name = "        "
    assert_not @user.valid?
  end

  test 'email validateion should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_UR-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?
    end
  end

  test 'email validateion should reject  invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "%{invalid_address.inspect} should be invalid"
    end
  end

  test 'password should be preent (nonblanck)' do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end
end
