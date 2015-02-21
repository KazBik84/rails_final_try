require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    # Resetuje array deliveries ponieważ jest to zmienna globalna i może zawierać 
    # jakieś śmieci
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "",
                               email: "user@invalid",
                               password: "foo",
                               password_confirmation: "bae" }
    end
    assert_template 'users/new'
    #Przeszukuje strone pod kątem div-a o id 'error_explanation'
    assert_select 'div#error_explanation'
    #Przeszukuje strone pod kątek div-a o klasie 'field_with_errors'
    assert_select 'div.field_with_errors'
  end
  
  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, user: { name: "Example Kazik",
                               email: "user@example.com",
                               password: "password",
                               password_confirmation: "password" }
    end
    # Założenie rozmiar array deliveries ma rozmiar 1
    assert_equal 1, ActionMailer::Base.deliveries.size
    # do zmiennej user przypisujemy obiekt user utworzony w kacji post chyba :D
    user = assigns(:user)
    # założenie że user nie jest akctywowany
    assert_not user.activated?
    # próba zalogowania użytkownika przy pomocy funkcji z test_helper.rb
    log_in_as(user)
    # Wyjdzie fałsz bo tylko aktywowany user może zdać test is_logged_in?
    assert_not is_logged_in?
    # Próba aktywowania przy pomocy złego tokeny
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # Próba aktywowania właściwym tokenem ale złym mailem
    get edit_account_activation_path(user.activation_token, email: "wrong")
    assert_not is_logged_in?
    # Poprawna aktywacja
    get edit_account_activation_path(user.activation_token, email: user.email)
    # reload - odświeża usera dzięki czemu można testować czy zmienił się status activated
    assert user.reload.acitvated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
=begin  
  Ta część została zastapiona w rozdziale 10.1.4 po dodaniu opcji aktywacji mailem
  
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
    #assert_template 'users/new'
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
    #assert_template 'users/show'
  end
  
  test "After succesfull signup user should be loggen in" do
    get signup_path
    post users_path, user: @valid_user
    #assert is_logged_in?
  end

=end
end
