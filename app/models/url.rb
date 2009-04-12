require 'open3'
class Url < ActiveRecord::Base
  def fetch_content
    cmd = "lynx -display_charset=utf8 -dump -nolist #{self.url}"
    out = ''
    err = ''
    Open3.popen3(cmd) do |stdin, stdout, stderr|
      stdin.close
      err = stderr.read
      out = stdout.read
    end
    if err != ''
      raise err
    else
      self.content = out
      save
    end
  end
end
