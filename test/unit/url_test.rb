require 'test_helper'

class UrlTest < ActiveSupport::TestCase
  test "should fetch url content" do
    content = urls(:google).get_content
    assert_not_nil content
    assert_match /About Google/, content
  end

  test "should notice content has changed" do
    url = urls(:google)
    url.update_content
    assert url.content
  end
end
