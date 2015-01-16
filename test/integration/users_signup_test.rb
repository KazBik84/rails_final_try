require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    @invalid_user = { name: "",
                      email: "user@invalid",
                      password: "foo",
                      password_confirmation: "bar"}
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
end
