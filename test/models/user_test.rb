require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Przykladowy Kazik", email: "kazik@example.com",
                      password: "foobar", password_confirmation: "foobar" )
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "K" * 51
    assert_not @user.valid?
  end
  
  test "email shoud not be too long" do
    @user.email = "B" * 256
    assert_not @user.valid?
  end
  
  test "email vaidation should accept addresses" do
    valid_adresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_adresses.each do |valid_adress|
      @user.email = valid_adress
      assert @user.valid?, "#{valid_adress.inspect} should be valid"
    end
  end
    
  test "authenticated? (funckja z modelu user.rb), powinna zwrócić fałsz, gdy
    user, remember_digest jest nilem" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "email validation should reject invalid addresses" do
    # %[...] tworzy array stringów
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com ]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      # druga zmienna to opcjonalny komentarz jesli test sie nie powiedzie
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.Com"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
end
