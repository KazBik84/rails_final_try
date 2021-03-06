require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest

  def setup
    # Czyści zbiór dostarczonych wiadomości, by móc poprawnie badać zachowanie testu
    ActionMailer::Base.deliveries.clear
    @user = users(:kask)
  end
  
  test "password reset" do 
    get new_password_reset_path
    assert_template 'password_resets/new'
    #Nieprawidłowy email, 'password_reset' to nazwa zbioru parametrów jakie przekażemy
    # email to przekazywany klucz a "" wartość
    post password_resets_path, password_reset: { email: "" }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Przekazany prawidłowy adres email
    post password_resets_path, password_reset: { email: @user.email }
    # test czy reset_digest zmienił się po wykonaiu akcji post, 'reload'
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    # Założenie że liczba wysłanych mailów jest równa 1
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Przypisanie do miennej obiektu do formularza resetu
    user = assigns(:user)
    # Zły email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # Funkcja toggle! zamienia wartość zmiennej logicznej (bolean) nazwa musi być podana jako symbol
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # Właściwy mail, zły token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    #Właściwy token, właściwy mail
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    # założenie że będzie obiek input, o name="email" type="hidden" value=podany mail
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Nie prawidłowe hasło i potwierdzenie
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password: "kurwaa",
                  password_confirmation: "mmaacc" }
    assert_select 'div#error_explanation'
    # Pust hasło
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password: " ",
                  password_confirmation: "kurwamac" }
    assert_template 'password_resets/edit'
    assert_not flash.empty?
    # Poprawne haslo i potwierdznie
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password: "foobar",
                  password_confirmation: "foobar" }
    # is_logged_in? to funkcja z test_helper
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path, password_reset: { email: @user.email }

    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
          email: @user.email,
          user: { password:              "foobar",
                  password_confirmation: "foobar" }
    assert_response :redirect
    follow_redirect!
    assert_match /expired/i, response.body
  end
end
