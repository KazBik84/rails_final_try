class MicropostsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	
	def create
		# current_user to funkcja zdefiniowana w sessions_helper.rb
		@micropost = current_user.micropost.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			render 'static_pages/home'
		end
	end
	
	def destroy
	end
	
	private 
	
		def micropost_params
			params.require(:micrpost).permit(:content)
		end
	
end
