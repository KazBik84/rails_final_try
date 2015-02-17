require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    #Przypisanie obiektu :kask z fixtures/users.yml do zmiennej user
    user = users(:kask)
    # Nadanie atrybutowi activation_token wartości z funkcji klasy User.new_token
    user.activation_token = User.new_token
    # pzypisanie do zmiennej mail, niewiadomo_czego z użytkownika user :((( 
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name,                mail.body.encoded
    assert_match user.activation_token,    mail.body.encoded
    # Forma wyciągnięcia maila użytkownika, znów mało rozumiem :((( 
    assert_match CGI::escape(user.email),  mail.body.encoded
  end
end
