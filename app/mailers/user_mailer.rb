class UserMailer < ActionMailer::Base
  default from: "noreply@example.com"

  def account_activation(user)
    @user = user
    # mail zostanie wysłany do user.email, a temat wiadomości to subject    
    mail to: user.email, subject: "Account activation"
  end

  #Funkcja odpowiedzialna za wysyłanie maili z resetem
  def password_reset(user)
    # Przypisanie atrybutu user do zmiennej instancji, by móc wykorzystać jej 
    # atrybuty w treści maila
    @user = user
    # mail zostanie wysłany do user.email, a temat wiadomości to subject
    mail to: user.email, subject: "Password reset"
  end
end