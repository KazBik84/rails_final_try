class AccountActivationsController < ApplicationController
  
  def edit
    user = User.find_by(email: params[:email])
    # jeśli user istnieje, nie jest aktywowany ale jest potwierdzone
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # funkcja z modelu user.rb
      user.activated
      # funkcja z session_helper
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
