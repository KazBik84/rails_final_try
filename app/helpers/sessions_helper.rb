module SessionsHelper
  
  #Funkcja która przypisuje id obiektu do hasha ciasteczka session pod 
  #  kluczem/symbolem :user_id
  def log_in(user)
    session[:user_id] = user.id
  end
  
    def current_user
      #jeśli do @current_user nie jest już przypisana jakaś wartość, przypisuje  
      #  do niego Wartość znalezioną w bazie danych.
      @current_user ||= User.find_by(id: session[:user_id])
    end
    
    def logged_in?
      # Funkcja sprawdza czy funkcja current_user jest nil. Jeśli nie jest to
      # dzięki zaprzeczeniu (! na początku) zwraca prawdę.
      !current_user.nil?
    end
    
    #Wylogowanie usera poprzez zniszczenie z hasha 'session' klucza "user_id" 
    # po którym rozpoznawany jest na stronie
    def log_out
      session.delete(:user_id)
      @current_user = nil
    end
end

