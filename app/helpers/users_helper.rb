module UsersHelper
  
  #Zwraca Gravatara dla konkretnego usera
  def gravatar_for(user, options = { size: 80 })
    # koduje wartość user.email.downcase, przy pomocy kodu MD%
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    # Tworzy link do gravatara dodając na koniec zakodowaną wartość maila    
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
