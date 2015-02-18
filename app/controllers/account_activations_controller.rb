class AccountActivationsController < ApplicationController
  
  def edit
    user = User.find_by(email: params[:email])
    # jeśli user istnieje, nie jest aktywowany ale jest potwierdzone
    if user && !user.activated? && user.authentificated?(:activation, params[:id])
      user.update_attribute(:activated, true)
      user.update_attribute(:activated_at, Time.zone.now)
      # funkcja z session_helper
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
    end
  end
end
