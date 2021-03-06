ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  #helpery z app nie są dostępne w testach dlatego musimy stworzyć taką samą metodę
  #  w helperze testów. Funkcja zwraca prawdę jeżeli wartość :user_id nie jest nilem.
  def is_logged_in?
    !session[:user_id].nil?
  end
  
  def log_in_as(user, options = {})
    password = options[:password] || 'password'
    remember_me = options[:remember_me] || '1'
    # integration test jest funkcją sprawdzającą rodzaj test, zdefiniowaną, w tym pliku
    if integration_test?
      post login_path, session: {email: user.email,
                                 password: password,
                                 remember_me: remember_me }
    else
      session[:user_id] = user.id
    end
  end
  
  private
  
  #funkcja sprawdza, czy dany test jest testem integracyjnym, czy innym. Działa to
  # dzięki funkcji defined, która sprawdza czy w danym kontekście możliwe jest wykorzystanie
  # funkcji 'post_via_redirect' która możliwa jest do wykorzystania tylko w testach integracyjnych
  def integration_test?
    defined?(post_via_redirect)
  end
end
