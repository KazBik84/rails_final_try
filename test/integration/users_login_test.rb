require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    # w ten sposób do zmiennej @user przypisujemy usera o nazwie kask zdefiniowanego
    # w test/fixtures/users.yml
    @user = users(:kask)
  end
  
  test "login with invalid information" do
    # prowadzi do strony login
    get login_path
    # założenie że wyświetli się strona 'sessions/new'
    assert_template 'sessions/new'
    # podanie POST do login_path, hashu wartości email i password. Nie można
    # skorzystaćz bazy danych bo niema modelu
    post login_path, session: {email: "", password: "" }
    assert_template 'sessions/new'
    # Założenie że hash 'flash' nie jest pusty
    assert_not flash.empty?
    get root_path
    # założenie że hash 'flash' jest pusty
    assert flash.empty?
  end
  
  test"login with valid information" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
  
  test "login with valid information followed by logout" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    #przesłanie żadania logout_path z akcją 'delete'
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    # symulowanie kliknięcia przycisku "log out" w innym oknie przeglądarki
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  
  test "login with remembering" do
    # log_in_as jest zdefiniowane w test_helper.rb
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end
  
  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
end
