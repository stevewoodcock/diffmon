require 'test_helper'
require 'mocha'

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

  test "should save diff when content changes" do
    url = urls(:google)
    url.expects(:get_content).returns("abc\n")
    url.update_content
    url.expects(:get_content).returns("def\n")
    url.update_content
    assert_match /^-abc/, url.diff
    assert_match /^\+def/, url.diff
  end

  test "should update all content" do
    Url.any_instance.stubs(:get_content).returns("some content")
    Url.update_all_content
    assert_equal Url.count, Url.count(:conditions => ["last_modified > ?", 1.minute.ago])
  end
end
