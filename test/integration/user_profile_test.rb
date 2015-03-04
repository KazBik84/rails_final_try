require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
	#Ładuje application_helper z 'app/helpers' by umożliwić badanie pełnego tytułu
	include ApplicationHelper
	
	def setup
		@user = users(:kask)
	end
	
	test "profile display" do
		get user_path(@user)
		assert_template 'users/show'
		assert_select 'title', full_title(@user.name)
		assert_select 'h1', text: @user.name
		# Założenie sprawdza czy istnieje div o klasie 'gravatar' w obiekcie h1
		assert_select 'h1>img.gravatar'
		# Założenie że na stronie 9response.body) znajdzie się liczba sumy postów
		assert_match @user.microposts.count.to_s, response.body
		assert_select 'div.pagination'
		@user.microposts.paginate(page: 1).each do |micropost|
			assert_match micropost.content, response.body
		end
	end
end
