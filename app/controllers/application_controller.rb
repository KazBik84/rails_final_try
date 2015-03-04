class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # Umieszczenie SessionsHelpera tutaj 'application_controller' sprawi że ten 
  #  helper będzie dostępny w każdym view i kontrolerze.
  include SessionsHelper
  
	private
	
		# Potwierdza że user jest zalogowany
		def logged_in_user
			unless logged_in?
				# funkcja z sessions_helper.rb która do sessions[:forwarding_url] przypisuje url który
        # chce użyć użytkownik
				store_location
				flash[:danger] = "Please log in."
				redirect_to login_url
			end
		end
end
