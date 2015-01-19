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
      #log the user in and redirect to the user`s show page
    else
      flash[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
  end
  
end
