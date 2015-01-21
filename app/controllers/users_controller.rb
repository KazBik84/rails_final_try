class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])  
  end
  
  def new
    #tworzy nowy obiekt i przypisuje go do zmiennej @user
    @user = User.new
  end
  
  def create 
    #tworzy nowy obiekt @user i przypisuje do niego wartości zapisane w user_params 
    #które otrzymał po wypełnionym formularzu w akcji 'new'
    @user = User.new(user_params)
    if @user.save #jesli uda sie zapisac obiekt do bazy danych
      #funcka zdefiniowana w 'sessions_helper', stworzy hash session i przypisze 
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
      render 'new' #przekierowuje do akcji 'new'
    end
  end
  
  private # wszystko po tej komendzie jest prywatne tylko dla users_controller
  
    #funkcja ta przyjmie wartości przesłane w params[:user] 
    #i zwróci tylko dopuszczone wartości
    def user_params
     params.require(:user).permit(:name, :email, :password,
                                    :password_confirmation) 
    end
end
