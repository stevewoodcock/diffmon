class AddRegexpToJobs < ActiveRecord::Migration
  def self.up
    execute <<EOF
alter table jobs add column regexp text;
EOF
  end

  def self.down
  end
end
