require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:kask)
  end
  
  test "unsuccessful edit" do
    # funkcja 'log_in_as' jest zdefiniowana w test_helper.rb w katalogu test
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: "",
                                    email: "brzydki@mail",
                                    password: "fuj",
                                    password_confirmation: "fuj2" }
    assert_template 'users/edit'                                    
  end
  
  test "successful edit" do
    # funkcja 'log_in_as' jest zdefiniowana w test_helper.rb w katalogu test
    log_in_as(@user)    
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name:  name,
                                    email: email,
                                    password:              "foobar",
                                    password_confirmation: "foobar" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name,  name
    assert_equal @user.email, email
  end
  
  
end
