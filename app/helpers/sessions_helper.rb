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
      #raise # jeśli program nie wywali nigdzie błędu w testach, znaczy że ta część 
      #  kodu jest nie przetestowana
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
    # Odwołanie do funckji forget, zdefiniowanej w user.rb która ustawia parametr
    # remember_digest na nil, żeby dało się na nowo zalogować
    forget(current_user)
    # skasowanie hasha session
    session.delete(:user_id)
    @current_user = nil
  end
  #funckcja która kasuje ciasteczka usera
  def forget(user)
    #odwołanie do funkcji z user.rb która zmienia atrybut usera :remember_digest na nil
    user.forget
    # kasowanie ciasteczek
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
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
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  #Funcka porównuj podanego 'usera' do wyniku funkcji, 'current_user'
  def current_user?(user)
    user == current_user
  end
end

