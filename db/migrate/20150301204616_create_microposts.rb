class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.text :content
			# Odniesienie do modelu 'user', tworzy kolumne 'user_id' 
			# a dodatkowo kolumny index i foreign_key
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :microposts, :users
		#Dodaje index mikropostow uzytkownika user_id w kolejnosci stworzenia
		# Zawarcie zbioru :user_id i created_at tworzy multi index i rails 
		# uzywa obu wartosci do pozycjonowania indexu
		add_index :microposts, [:user_id, :created_at]
  end
end
