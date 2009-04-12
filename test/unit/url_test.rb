require 'test_helper'

class UrlTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should fetch url content" do
    url = urls(:djangobook)
    url.fetch_content
    assert_not_nil url.content
    assert_match /Caching/, url.content
  end
end
