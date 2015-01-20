require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
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
end
