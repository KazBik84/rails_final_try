require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test 'should get home view' do
    get root_path
    assert_template 'static_pages/home'
  end
  
  test 'root should have two root_paths' do
    get root_path
    assert_select "a[href=?]", root_path, count: 2
  end
  
  test 'root should have help link' do
    get root_path
    assert_select "a[href=?]", help_path
  end
  
  test 'root should have about link' do
    get root_path
    assert_select "a[href=?]", about_path
  end
  
  test 'root should have contact link' do
    get root_path
    assert_select "a[href=?]", contact_path    
  end
end
