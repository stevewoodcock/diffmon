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

  test "should delete job" do
    delete :destroy, :id => jobs(:google)
    assert_redirected_to jobs_path
  end
end
