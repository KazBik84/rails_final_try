class UsersController < ApplicationController
  # before action wywoła funkcję 'logged_in_user' przed wykonaniem akcji podanych
  # w hashu 'only'
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    #User.paginate jest wymuszone wykorzystaniem gemu 'will_paginate' który dzieli
    # zawartość zmiennej @users na strony. params page jest tworzony przez ten gem.
		# Where jest warunkiem, ktory musi zaistnaiec.
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])  
    # do zmiennej @microposts, przypisujemy mikroposty należące do obiektu przypisanego
    # 	obecnie do zmiennej @user na których wykorzystano gem will_paginate
		@microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
    #tworzy nowy obiekt i przypisuje go do zmiennej @user
    @user = User.new
  end
  
  def create 
    #tworzy nowy obiekt @user i przypisuje do niego wartości zwrócone przez funkcje
    # 'user_params' która jest prywatną funkcją tego kontrolera a
    #które otrzymał po wypełnionym formularzu w akcji 'new'
    @user = User.new(user_params)
    if @user.save #jesli uda sie zapisac obiekt do bazy danych
        # Stare!! log_in to funcka zdefiniowana w 'sessions_helper', stworzy hash session i przypisze 
        # Stare!! @user.id do klucza session[:user_id]
        # Stary kod !! >> log_in @user
      #Funkcja zdefiniowana w user.rb
      @user.send_activation_email
      #flash to wartość która istenieje tylko na czas najbliższej akcji przeglądarki
        # Stare!! w tym przypadku pojawi się tylko jeśli akcja została przeprowadzona pomyślnie
        # Stare !!success. I wygeneruje tekst "Welcome .... "
        #flash[:success] = "Welcome to the Sample App Kazika!"
      # w tym przypadku zostanie wygenerowany flash o fladze info z tekstem. 
      flash[:info] = "Please check your email to activate your account"
        # użytkownik zostanie przekierowany do user_url(@user), czyli do user_path(id)
        # czyli akcji show z kontrolera Users
        # redirect_to @user
      redirect_to root_url
    else
      render 'new' #przekierowuje do akcji 'new' zkontrollera users
    end
  end
  
  def edit
    # zapisanie obiektu do zmiennej instancji, pozwoli na korzystanie z jego zasobów
    # w stronie edit.html.erb
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  # funkcja odnajduje uytkownika do zniszczenia po przełanym id, i wykonuje na obiekcie 
  # akcje destroy, po czym przekierowuje do strony z użytkownikami i wyświetla flasha.
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end    
  
  private # wszystko po tej komendzie jest prywatne tylko dla users_controller
  
    #funkcja ta przyjmie wartości przesłane w params[:user] 
    #i zwróci tylko dopuszczone wartości
    def user_params
     params.require(:user).permit(:name, :email, :password,
                                    :password_confirmation ) 
    end
    
    # Before filters
    
    #Potwierdza czy user jest zalogowany
    def logged_in_user
      #jeżeli funkcja logged_in? która zdefiniowana jest w sessions_helper.rb,
      # nie jest prawdą
      unless logged_in?
        # funkcja z sessions_helper.rb która do sessions[:forwarding_url] przypisuje url który
        # chce użyć użytkownik
        store_location
        flash[:danger] = "Prosze się zalogować"
        redirect_to login_url
      end
    end
    
    # Funkcja do potwierdzenie że użytkownik sięga tylko po dostępne opcje.
    
    def correct_user
      #Przypisanie do zmiennej @user użytkownika, znaleznionego po id które
      # które przesyłamy do akcji
      @user = User.find(params[:id])
      #Przekierowanie do url, jeśli funkcja 'current_user?' z sessions_helper
      # nie zwróci prawdy. Czyli jeśli zalogowany użytkownik, stara się uzyskać 
      # dostęp do swoich zasobów. 
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def admin_user
      # funkcja current_user jest zdefiniowana w sessions_helper.rb
      redirect_back_or(root_url) unless current_user.admin?
    end
end
