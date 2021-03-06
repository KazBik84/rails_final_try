require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

	def setup
		@user = users(:kask)
		# Wcześniejsza wersja zapisu która była niewłaścia idiomatycznie
		#@micropost = Micropost.new(content: "Kazimierz Wielki", user_id: @user.id)
		
		# Nowy sposób zapisu korzystający z tego że połączyliśmy usera i microposty
		# @user.micropost - automatycznie łączy id usera z powstającym micrpostem
		# build - tworzy obiekt w pamięci ale nie zapisuje go w bazie danych
		# WAŻNE!!! w takim zapisie należy użyć l.mnogiej obiektu !!!
		@micropost = @user.microposts.build(content: "Kazik jest wielki :) ")
	end
	
	test "should be valid" do
		assert @micropost.valid?
	end
	
	test "user id should be present" do
		@micropost.user_id = nil
		assert_not @micropost.valid?
	end
	
	test "content should be present" do
		@micropost.content = " "
		assert_not @micropost.valid?
	end
	
	test "content should be at most 140 characters" do
		@micropost.content = "a" * 666
		assert_not @micropost.valid?
	end
	
	test "order should be most recent first" do
		assert_equal Micropost.first, microposts(:most_recent)
	end
end
