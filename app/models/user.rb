class User < ActiveRecord::Base
  attr_accessor :remember_token
  # call back - czyli procedura ktora zostanie wykonana 
  #             przed wykonaniem akcji w tym przypadku
  #             przed save
  before_save { email.downcase! }# to to samo co => self.email = email.downcase 
  validates :name, { presence: true, length: { maximum: 50 } }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, { presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false } }
  validates :password, { length: { minimum: 6 } }
  has_secure_password
  
  # Funkcje zwraca zakodowaną wersję podanego stringu. W zależności czy odbywa się 
  # to w testach czy w produkcji kodowanie jest proste lub złożone.
  def User.digest(string)
    # określa stopień kodowania w zależności czy funkcjonuje w środowisku test 
    # czy produkcja..... chyba .... ????
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
                                                  BCrypt::Engine.cost
    # zwraca zakodowaną wersję zmiennej 'string'
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Zwraca wygenerowany losowo token
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # Zapamiętuje Usera w bazie danych, by potem móc użyć go w trwałej sesji. ????
  def remember
    #przypisuje do user.remember_token wartość zwróconą przez funkcję User.new_token
    self.remember_token = User.new_token
    # aktualizuje zmienną :remember_digest Usera, zakodowaną wartością remember_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  # funkcja zwraca prawdę jeżeli wartośćtokenu odpowiada wartości remember_digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    # porównuje w chuj wie jaki sposób remeber_digest zapisany w bazie danych
    # z wartością remember_token z ciasteczka
    BCrypt::Password.new(remember_digest.is_password?(remember_token))
  end
  
  # Funkcja która "zapomina" user, czyi ustawia jego remember_digest na nil
  def forget
    update_attribute(:remember_digest, nil)
  end
end
