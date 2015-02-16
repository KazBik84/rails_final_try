# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at  https://rails-final-try-kask666.c9.io/rails/mailers/user_mailer/account_activation
  def account_activation
    # Przypisanie do zmiennej user, pierwszego obiektu z bazy danych User
    user = User.first
    # Przypisanie do zmiennej user parametru activation_token o wartości 
    # uzyskane z funkcji klasy User.new_token
    user.activation_token = User.new_token
    # Użycie funkcji z przypisanym do niej obiektem zapisanym w zmiennej 'user'
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    UserMailer.password_reset
  end

end
