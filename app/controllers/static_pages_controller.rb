class StaticPagesController < ApplicationController
  def home
  	if logged_in?
			@micropost = current_user.microposts.build if logged_in?
			# '.feed' jest odniesieniem do funkcji z umodel user.rb, która zwraca posty 
			#		usera z bazy danych
			@feed_items = current_user.feed.paginate(page: params[:page])
		end
  end

  def help
  end
  
  def about
  end

  def contact
  end
end
