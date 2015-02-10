class AddAdminToUsers < ActiveRecord::Migration
  def change
    # Domyślnie zmienna była by nil, czyli fałsz, ale dodanie opcji hasha, default 
    #sprawia że kod jest czytelniejszy.
    add_column :users, :admin, :boolean, default: false
  end
end
