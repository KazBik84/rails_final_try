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
      # odwołanie do funkcji zdefiniowanych w session_helper.rb która tworzy
      #  pernamentne ciasteczka u użytkownika lub je niszczy w zależności od 
      #  remember_me
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
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
  end
  
  def destroy
    #funkcja niszcząca hash session zdefiniowana w app/helpers/sessions_helper.rb
    # które jest prawdziwa tylko gdy, funkcja logged_in? z session_helper.rb zwróci prawdę,
    # czyli w sytuacji gdy current_user nie jest nilem.
    log_out if logged_in?
    redirect_to root_path
  end
  
end
