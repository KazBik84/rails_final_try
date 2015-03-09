class MicropostsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	# correct_user jest zdefiniowany w prywatnych funkcjach
	before_action :correct_user, only: :destroy
	
	def create
		# current_user to funkcja zdefiniowana w sessions_helper.rb
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end
	
	def destroy
		@micropost.destroy
		flash[:success] = "Micropost deleted"
		# request.reffer zwraca poprzedni adres url. User wróci więc do strony 
		# na której napisal posta.
		redirect_to request.referrer || root_url
	end
	
	private 
	
		def micropost_params
			params.require(:micropost).permit(:content, :picture)
		end
		
		def correct_user
			# przypidanie do zmiennej @micrpost, mikroposta znalezionego u wskazanego 
			#		użytkownika po id postu. 
			@micropost = current_user.microposts.find_by(id: params[:id])
			redirect_to root_url if @micropost.nil?
		end
	
end
