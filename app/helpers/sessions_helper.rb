module SessionsHelper
  
  #Funkcja która przypisuje id obiektu do hasha ciasteczka session pod 
  #  kluczem/symbolem :user_id
  def log_in(user)
    session[:user_id] = user.id
  end
end

