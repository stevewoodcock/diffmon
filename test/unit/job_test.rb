require 'test_helper'
require 'mocha'

class JobTest < ActiveSupport::TestCase
  test "should fetch job content" do
    content = jobs(:google).get_content
    assert_not_nil content
    assert_match /About Google/, content
  end

  test "should notice content has changed" do
    job = jobs(:google)
    job.update_content
    assert job.content
    assert job.last_modified
  end

  test "should notice content has not changed" do
    job = jobs(:google)
    job.update_content
    last = job.last_modified
    job.update_content
    assert_equal last, job.last_modified, "Last modified should not change"
  end

  test "should save diff when content changes" do
    job = jobs(:google)
    job.expects(:get_content).returns("abc\n")
    job.update_content
    job.expects(:get_content).returns("def\n")
    job.update_content
    assert_match /^-abc/, job.diff
    assert_match /^\+def/, job.diff
  end

  test "should update all content" do
    Job.any_instance.stubs(:get_content).returns("some content")
    Job.update_all_content
    assert_equal Job.count, Job.count(:conditions => ["last_modified > ?", 1.minute.ago])
  end
end
