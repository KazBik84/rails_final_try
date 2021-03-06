class PasswordResetsController < ApplicationController
  
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
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
  
  def update
    if password_blank?
			flash.now[:danger] = "Password can't be blank"
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  
    # Pozwala na przesłanie dalej tylko parametrów :password i password_confirmation
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    #Zwraca prawde jeżeli przesłąne hasło jest puste
    def password_blank?
      params[:user][:password].blank?
    end
    
    # Funkcja wyszukuje żywtkoenika po mailu i zapisuje do zmniennej
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    #Funckcja sprawdza czy podany użytkownik istnieje, jest aktywny i czy zgadza się jego token
    def valid_user 
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    def check_expiration
      # password_reset_expired pochodzi z modelu user.rb
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired"
        redirect_to new_password_reset_url
      end
    end
end
