require 'open3'

class Url < ActiveRecord::Base
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
      save
    end
  end
end
