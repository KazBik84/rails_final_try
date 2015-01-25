module SessionsHelper
  
  #Funkcja która przypisuje id obiektu do hasha ciasteczka session pod 
  #  kluczem/symbolem :user_id
  def log_in(user)
    session[:user_id] = user.id
  end
  
    def current_user
      if session[:user_id] # to to samo co: user_id = session[:user_id], czyli jeśli 
                           # user_id to session[:user_id] wtedy true
        #jeśli do @current_user nie jest już przypisana jakaś wartość, przypisuje  
        #  do niego Wartość znalezioną w bazie danych.
        @current_user ||= User.find_by(id: session[:user_id])
      elsif cookies.signed[:user_id] # to samo co user_id = cookies.signed[:user_id]
        user = User.find_by(id: cookies.signed[:user_id])
        if user && user.authenticated?(cookies[:remember_token])
          log_in user
          @current_user = user
        end
      end
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
    
    # funkcja najpierw korzysta z funkcji remember z modelu user.rb, następnie
    #  tworzy pernamentne cisteczko z wartością :user_id i przypisuje do niego id 
    #  użytkownika, następnie utworzony wcześniej zakodowany remember_token
    #  przypisujemy do klucz :remember_token
    def remember(user)
      user.remember
      # cookies oznacza że będziemy korzystać  z funkcji cookies, 
      #  pernament że ciasteczko wygaśnie po 20 latach (taka konwencja)
      #  signed oznacza że wartość jest kodowana.
      cookies.pernament.signed[:user_id] = user.id
      cookies.pernament[:remember_token] = user.remember_token
    end

end

