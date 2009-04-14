require 'test_helper'

class JobsControllerTest < ActionController::TestCase

  test "should return Atom feed" do
    get :index, :format => 'atom'
    assert_response :success
  end

  test "should list jobs" do
    get :index
    assert_response :success
  end

  test "should show job" do
    get(:show, {:id => jobs(:google)})
    assert_response :success
  end

  test "should show new job form" do
    get :new
    assert_response :success
  end

  test "should create job" do
    post :create, :post => { :url => 'abc' }
    assert_redirected_to jobs_url
  end
end
