class SessionsController < ApplicationController
  def new
  end
  
  def create
    # do zmiennej 'user' przypisany zostanie obiekt znaleziony w bazie po 
    #  wartosci email znajdującej się w hashu 'session' ktory jest 
    #  weznątrz hashu 'params'
     user = User.find_by(email: params[:session][:email].downcase)
    # jeżeli 'user' istnieje i wartosc jego hasla zgodna jest z podana wartoscia
    # hasla wtedy zwracana jest prawda. funkcja 'authenticate' jest czescia metody 
    # 'has_secure_password' której użylismy w modelu User.
    if user && user.authenticate(params[:session][:password])
      # po autentyfikacji przypisujemy usera do session[:user_id] 
      # funkcja log_in(user) znajduje się w app/helpers/sessions_helper.rb 
      log_in user # to to samo co log_in(user)
      redirect_to user
    else
      # używamy flash.now zamiast flash, ponieważ flash pozostaje do następnego 
      # żądania w tym przypadku 'render' nie jest żądaniem, flash zostanie więc również 
      # na następnej wyświetlonej stronie. 
      
      # Flash.now działa tylko teraz nie do pierwszego żądania, dlatego
      # po żądaniu kolejnym po render 'new', flash zniknie.
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
    
    def current_user
      #jeśli do @current user nie jest już przypisana jakaś wartość, przypisuje  
      #  do niego Wartość znalezioną w bazie danych.
      @current_user ||= User.find_by(id: session[:user_id])
    end
    
    def logged_in?
      # Funkcja sprawdza czy funkcja current_user jest nil. Jeśli nie jest to
      # dzięki zaprzeczeniu (! na początku) zwraca prawdę.
      !current_user.nil?
    end
  end
  
  def destroy
  end
  
end