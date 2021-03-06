require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:kask)
    @other_user = users(:michael)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    # do akcji edit, przypisujemy tylko id: @user bo domyślną wartością jest user.id 
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    # w tym przypdadku do hasha należało przypidaść konkretne atrybuty obiektu @user
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user 
    end
  end
  
  test "should redirect destroy when logged in as a non-admon" do
    #funkcja log_in_as jest w test_helper
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      #delete to typ żadania, a destroy to nazwa akcji w kontrolerze
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end
  
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch :update, id: @other_user, user: { password:              "foobar",
                                            password_confirmation: "foobar",
                                            admin: true }
    assert_not @other_user.reload.admin?
  end  
  
  test "should redirect following when not logged in" do
  	get :following, id: @user
  	assert_redirected_to login_url
  end
  
  test "should redirected followers when not logged in" do
  	get :followers, id: @user
  	assert_redirected_to login_url
  end
end
