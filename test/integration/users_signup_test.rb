require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    @invalid_user = { name: "",
                      email: "user@invalid",
                      password: "foo",
                      password_confirmation: "bar"}
    
    @valid_user = { name: "Kazik haslo: foobar",
                    email: "kazik@costam.pl",
                    password: "foobar",
                    password_confirmation: "foobar"}

  end
  
  test "the number of object in DB should not chenge with invalid parameters" do
    # podaje signup_path
    get signup_path
    # założenie które będzie prawdziwe jeśli stan podanej zmiennej (user.count)
    # na koniec bloku się nie zmieni
    assert_no_difference 'User.count' do
      post users_path, user: @invalid_user
    end
  end
  
  test "After failed signup user should be redirected to the signup_path" do
    get signup_path
    post users_path, user: @invalid_user
    assert_template 'users/new'
  end
  
  test "After succesfull signup User.count shuold change" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, user: @valid_user
    end
  end
  
  test "After succesfull signup user should end on the user page" do
    get signup_path
    post_via_redirect users_path, user: @valid_user
    assert_template 'users/show'
  end
  
  test "After succesfull signup user should be loggen in" do
    get signup_path
    post users_path, user: @valid_user
    assert is_logged_in?
  end
end
