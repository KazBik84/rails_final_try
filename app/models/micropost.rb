class Micropost < ActiveRecord::Base
	# Oznaczna że ten model jest połączony 'jest podlegly' modelowi user
  belongs_to :user
  # default_scope to funkcja rails, która ustawia/dopusza,
  #		obiekty w określony sposób lub o określonych właściwościach
  # '->' to dźgająca lambda czyli ustanowienie procedury(bloku) bez nazwy
  # 'order' to także funkcja railsów która określa kolejność kolejki obiektów
  #		w tym przypdaku kolejność jest ustalana wg. atrybutu 'created_at', 
  #		a symbol ':desc' oznacza, że kolejność będzie malejąca
  default_scope -> { order(created_at: :desc) }
  # Funkcja mount_uploader pochodzi z gema CarrierWave, odpowiedzialnego
  #		za upload obrazów.
  # By połączyć obrazek z obiektem modelu należy podać nazwę atrybutu(modelu), 
  #		do któej zostanie zapisany, jako symbol ':picture' oraz nazwę uploadera 
  #		'PictureUploader', która zdefiniowana jest w app/uploader/picture_uploader
  #	Plik picture uploader został wygenerowany poprzez generator
  #		'rails generate uploader Picture', gdzie picture to nazwa zmiennej. 
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  # !!!! validate to nie to samo co validates !!!!
  #		validate oznacza wlasna walidacje, którą nalezy zdefiniować
  validate :picture_size
  
  private
  	
  	# Sprawdza rozmiar pliku
  	def picture_size
  		if picture.size > 5.megabytes
  			errors.add(:picture, "should be less than 5MB")
  		end
  	end
end
