require 'open3'

class Job < ActiveRecord::Base
  validates_format_of :url, :with => /^\w+:\/\/.+/

  def get_content
    cmd = "lynx -display_charset=utf8 -dump -nolist #{self.url}"
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
      if self.prior_content
        content_tmp = Tempfile.new('content')
        content_tmp.write content
        content_tmp.flush
        cmd = "diff --unified - #{content_tmp.path}"
        status = systemu cmd, 0=>prior_content, 1=>stdout='', 2=>stderr=''
        content_tmp.close!
        raise stderr if stderr != ''
        self.diff = stdout
      end
      save
    end
  end

  def self.update_all_content
    Job.all.each do |url|
      url.update_content
    end
  end
end
