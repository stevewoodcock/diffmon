require 'test_helper'

class UrlsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "should return Atom feed" do
    get :index, :format => 'atom'
    assert_response :success
  end
end
