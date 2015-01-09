class User < ActiveRecord::Base
  # call back - czyli procedura ktora zostanie wykonana 
  #             przed wykonaniem akcji w tym przypadku
  #             przed save
  before_save { self.email = email.downcase }
  validates :name, { presence: true, length: { maximum: 50 } }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i  
  validates :email, { presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false } }
  has_secure_password
end
