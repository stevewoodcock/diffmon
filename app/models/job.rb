require 'open3'

class Job < ActiveRecord::Base
  validates_format_of :url, :with => /^\w+:\/\/.+/

  before_save :maybe_update_diff

  def get_content
    cmd = "/opt/local/bin/lynx -display_charset=utf8 -dump -nolist '#{self.url}'"
    status, stdout, stderr = systemu cmd
    raise stderr if stderr != ''
    stdout
  end

  def update_content
    content = get_content
    if content != self.content
      self.prior_content = self.content
      self.content = content
      self.last_modified = Time.now
      save
    end
  end

  def get_diff
    content_tmp = Tempfile.new('content')
    content_tmp.write self.filtered_content
    content_tmp.flush
    cmd = "diff --unified - #{content_tmp.path}"
    status = systemu cmd, 0=>self.filtered_prior_content, 1=>stdout='', 2=>stderr=''
    content_tmp.close!
    raise stderr if stderr != ''
    stdout
  end

  def filtered_content
    filter(self.content)
  end

  def filtered_prior_content
    filter(self.prior_content)
  end

  def filter(text)
    return text if self.regexp.blank?
    re = Regexp.new(self.regexp, Regexp::IGNORECASE | Regexp::MULTILINE)
    match = text.match(re)
    return nil unless match
    return match[1] if match.length > 1
    return match[0]
  end

  def maybe_update_diff
    if (self.regexp_changed? || self.content_changed?) && self.prior_content
      self.diff = get_diff
    end
  end

  def self.update_all_content
    Job.all.each do |url|
      url.update_content
    end
  end
end
