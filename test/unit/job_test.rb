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

  test "should require valid url" do
    job = Job.new(:url => 'abc')
    assert !job.save
    assert job.errors.on(:url)
  end

  test "filtered content" do
    job = jobs(:google)
    job.regexp = '(\d+)$'
    job.content = "testing 123\n"
    job.prior_content = "testing\n"
    assert_equal "123", job.filtered_content
    assert_equal nil, job.filtered_prior_content
  end

  test "diff respects regexp if set" do
    job = jobs(:google)
    job.regexp = '(\d+)$'
    job.content = "testing 123\n"
    job.prior_content = "testing 456\n"
    diff = job.get_diff
    assert_match /^-456/, diff
    assert_match /^\+123/, diff
  end

  test "diff is recalculated with regexp changes" do
    job = jobs(:google)
    job.expects(:get_content).returns("abc\ndef")
    job.update_content
    job.expects(:get_content).returns("abc\ntada\ndef")
    job.update_content
    job.regexp = "(tada)"
    job.save
    assert_match /^\+tada/, job.diff
    job.regexp = "(todo)"
    job.save
    assert_equal "", job.diff
  end

  test "regexp is case insensitive and multiline" do
    job = jobs(:google)
    job.expects(:get_content).returns("abc\ndef")
    job.update_content
    job.expects(:get_content).returns("abc\TADA\nline2\n\ndef")
    job.update_content
    job.regexp = "(tada.*)\n\n"
    job.save
    assert_match /\+TADA\n\+line2/m, job.diff
  end

  test "regexp filters on first bracket else full match" do
    job = jobs(:google)
    job.expects(:get_content).returns("abc\ndef")
    job.update_content
    job.expects(:get_content).returns("abc\nlooooooooooong\ndef")
    job.update_content
    job.regexp = "lo+ng"
    job.save
    assert_match /\+lo+ng/, job.diff
    job.regexp = "l(o+)ng"
    job.save
    assert_match /\+o+$/, job.diff
  end

end
