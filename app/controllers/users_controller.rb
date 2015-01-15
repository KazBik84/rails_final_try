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
      #tralalala
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
