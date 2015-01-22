class User < ActiveRecord::Base
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
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
