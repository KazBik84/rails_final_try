class PasswordResetsController < ApplicationController
  def new
  end

  def create
    #Znalezienie obiektu po hashu password_reset[:email] i przypisanie do zmiennej @user
    @user = User.find_by(email: params[:password_reset][:email].downcase)  
    #Jeżeli @user istnieje w bazie danych
    if @user
      #funkcja create_reset_digest jest w modelu user.rb
      @user.create_reset_digest
      #funkcja send_password_reset_email jest w modelu user.rb      
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instruction..Kazik pozdrawiam :)"
      redirect_to root_url
    else
      #flash.now ponieważ nie zachodzi redirect tylko render
      flash.now[:danger] = "email address not found, oszukujesz !! :)"
      render 'new'
    end
  end
  
  def edit
  end
end
