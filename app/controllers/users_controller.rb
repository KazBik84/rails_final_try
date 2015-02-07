class UsersController < ApplicationController
  # before action wywoła funkcję 'logged_in_user' przed wykonaniem akcji podanych
  # w hashu 'only'
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])  
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
      # log_in to funcka zdefiniowana w 'sessions_helper', stworzy hash session i przypisze 
      #  @user.id do klucza session[:user_id]
      log_in @user
      #flash to wartość która istenieje tylko na czas najbliższej akcji przeglądarki
      # w tym przypadku pojawi się tylko jeśli akcja została przeprowadzona pomyślnie
      # success. I wygeneruje tekst "Welcome .... "
      flash[:success] = "Welcome to the Sample App Kazika!"
      # użytkownik zostanie przekierowany do user_url(@user), czyli do user_path(id)
      # czyli akcji show z kontrolera Users
      redirect_to @user
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
  
  private # wszystko po tej komendzie jest prywatne tylko dla users_controller
  
    #funkcja ta przyjmie wartości przesłane w params[:user] 
    #i zwróci tylko dopuszczone wartości
    def user_params
     params.require(:user).permit(:name, :email, :password,
                                    :password_confirmation) 
    end
    
    # Before filters
    
    #Potwierdza czy user jest zalogowany
    def logged_in_user
      #jeżeli funkcja logged_in? która zdefiniowana jest w sessions_helper.rb
      unless logged_in?
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
end
