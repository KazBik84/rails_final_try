class User < ActiveRecord::Base
	# Oznaczenie że z modelem user jest połączona podległa baza 'microposts' i że 
	# 	do obiektu user może być przypisanych wiele micropostow
	# Dependent: :destroy oznacza że istnienie obiektow 'mikropost' nalezacych do 
	#		danego obietku user, jest zalezne od akcji destroy. Gdy zniknie user, znikna mikrposty
	has_many :microposts, dependent: :destroy # l. mnoga!!!
	
	# Żeby móc zapisac że obiekt user has_many :active_relationships który to model nie istnieje
	#		musimy podać Railsom, nazwę klasy modelu do którego się odnosimy, i klucz pod którym  
	#		user będzie zapisany.
	has_many :active_relationships, class_name: "Relationship",
																	foreign_key: "follower_id",
																	dependent: :destroy
																	
	has_many :passive_relationships, class_name: "Relationship",
																	 foreign_key: "followed_id",
																	 dependent: :destroy																	
																	
	#Obiek ma wiele 'following', z tabeli 'active_relationships' zdefiniowanego 
	#		wczesniej ??, ale ze 'followed'jest prawidlowa forma a nie 'following'
	#		poprzez source 'followed' mozemy zapisac 'following' lub cokolwiek innego
	# 	bo Railsy i tak poszukaja po followed 																	
	has_many :following, through: :active_relationships, source: :followed
	has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token, :activation_token, :reset_token
  
  # call back - czyli procedura ktora zostanie wykonana 
  #             przed wykonaniem akcji w tym przypadku
  #             przed save
  before_save :downcase_email
  
  # Akcja before create działą jak nazwa wskazuje tylko przed akcją create, nie 
  # przed akcja update. Funkcja create_activation_digest jest prywatną 
  # funkcją tego modelu.
  before_create :create_activation_digest
  validates :name, { presence: true, length: { maximum: 50 } }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, { presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false } }
  validates :password, { length: { minimum: 6 }, allow_blank: true }
  has_secure_password
  
  # Funkcje zwraca zakodowaną wersję podanego stringu. W zależności czy odbywa się 
  # to w testach czy w produkcji kodowanie jest proste lub złożone.
  
  # w tym przypadku self odnosi się od obiektu User
  #def self.digest(string)
  
  #stworzenie klasy która dziedziczy z 'self' pozwala pominąc je w nazwach metod
  class << self
    
    def digest(string)
      # określa stopień kodowania w zależności czy funkcjonuje w środowisku test 
      # czy produkcja..... chyba .... ????
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
                                                  BCrypt::Engine.cost
      # zwraca zakodowaną wersję zmiennej 'string'
      BCrypt::Password.create(string, cost: cost)
    end
  
    # Zwraca wygenerowany losowo token
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
  
  # Zapamiętuje Usera w bazie danych, by potem móc użyć go w trwałej sesji. ????
  def remember
    #przypisuje do user.remember_token wartość zwróconą przez funkcję User.new_token
    self.remember_token = User.new_token
    # aktualizuje zmienną :remember_digest Usera, zakodowaną wartością remember_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # funkcja zwraca prawdę jeżeli wartość tokenu odpowiada wartości 'digest' tego tokenu
  def authenticated?(attribute, token)
    # do zmiennej przesyłany jest parametr który tworzony jest z atrybutu 'atrribute'
    # i stałej '_digest' w ten sposób można przesłać np remember i stworzyć remember_digest
    # podobnie jak activation i stworzyć activation_digst
    digest = send("#{attribute}_digest")# 'send' jako krótsza wersja 'self.send'
    return false if digest.nil?
    # porównuje w chuj wie jaki sposób digest zapisany w bazie danych
    # z wartością token z ciasteczka
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # Funkcja która "zapomina" user, czyi ustawia jego remember_digest na nil
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # Zmienia atrybuty 'activated' i 'activated_at' danego obiektu
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Funkcja wysyła maila aktywacyjnego
  def send_activation_email
    #funkcja używa nazwy mailera (Usermailer) i korzysta ze zdefiniowanej tam funkcji
    # account_activation
    UserMailer.account_activation(self).deliver_now
  end
  
  #Tworzy nowy reset token i modyfikuje obiekt (wartość reset_token i reset_sent_at)
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  #Funkcja wysyła maila z reset_tokenem
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  #Funkcja sprawdza czy ważnośc klucza reset wygasła
  def password_reset_expired?
    # reset_sent_at jest atrybutem (data) obiektu user
    reset_sent_at < 2.hours.ago  
  end
  
  #Funkcja która wyszukuje wszystkie posty użytkownika
  # Taki sposób zapisu chroni przed 'SQL injection' które 
  #		może stanowić zagrożenie dla bezpieczeństwa. 
  #Micropost.where("user_id = ?", id)
  
  # following_ids jest wbudowana funkcją Active Records, a wygląda mniej więcej tak:
  #		User.first.following.map{ |i| i.to_s } << zwraca liste uzytkownikow sledzacych pierwszego uzytkownika
  #		User.first.following.map(&:to_s) to to samo co: .map{ |i| i.to_s }
  # A User.first.following.map(&:id) zwraca zbior id wszystkich obiektow following podanego obiektu
  # A że .following.map(&:id) jest bardzo popularne można to zastapić skrótem .following_ids
  # following_ids zostało zmienione by efektywniej przeszykiwać SQL
  def feed
  
  	following_ids = "SELECT followed_id FROM relationships
  									 WHERE follower_id = :user_id"
		Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end
  
  
  def follow(other_user)
  	# Tworzy wiersz w active_relationships, pomiędzy obiektem user (self które zostało pominięte)
  	#		a obiektem z parametru
    active_relationships.create(followed_id: other_user.id)
  end 
  
  def unfollow(other_user)
  	# Łańcuch funkcji, najpier wiersz z relacją jest znajdowany po followed_id
  	#		a następnie na nim wykonywana jest akcja destroy
  	active_relationships.find_by(followed_id: other_user.id).destroy
  end 
  
  def following?(other_user)
  	#Sprawdza czy zbiór (pominiętego) self, zawiera other_user 
  	following.include?(other_user)
  end
  private
  
    # funkcja zmienia email na małe litery
    def downcase_email
      self.email = email.downcase
    end
   
    # Funckaj tworzy actiation token oraz tworzy
    # activation digest ktory zostanie wyslany do uzytkownika.
    def create_activation_digest
      # PRzypisanie wygenerowanego tokenu, przy pomocy funkcji new_token
      self.activation_token = User.new_token
      # zakodowanie activation tokenu. 
      self.activation_digest = User.digest(activation_token)
    end
    

end
