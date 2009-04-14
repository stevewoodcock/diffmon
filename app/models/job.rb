require 'open3'

class Job < ActiveRecord::Base
  validates_format_of :url, :with => /^\w+:\/\/.+/

  def get_content
    cmd = "lynx -display_charset=utf8 -dump -nolist #{self.url}"
    out = ''
    err = ''
    Open3.popen3(cmd) do |stdin, stdout, stderr|
      stdin.close
      err = stderr.read
      out = stdout.read
    end
    raise err if err != ''
    out
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
        content_tmp.close
        cmd = "diff --unified - #{content_tmp.path}"
        out = ''
        err = ''
        Open3.popen3(cmd) do |stdin, stdout, stderr|
          stdin.write prior_content
          stdin.close
          err = stderr.read
          out = stdout.read
        end
        content_tmp.close!
        raise err if err != ''
        self.diff = out
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
