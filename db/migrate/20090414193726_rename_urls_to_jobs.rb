class RenameUrlsToJobs < ActiveRecord::Migration
  def self.up
    execute <<EOF
alter table urls rename to jobs;
EOF
  end

  def self.down
  end
end
