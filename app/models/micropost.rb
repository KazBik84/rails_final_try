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
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
