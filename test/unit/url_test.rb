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
    assert url.last_modified
  end

  test "should notice content has not changed" do
    url = urls(:google)
    url.update_content
    last = url.last_modified
    url.update_content
    assert_equal last, url.last_modified, "Last modified should not change"
  end
end
