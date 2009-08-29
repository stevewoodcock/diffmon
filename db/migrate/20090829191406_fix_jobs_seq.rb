class FixJobsSeq < ActiveRecord::Migration
  def self.up
    execute <<EOF
alter SEQUENCE urls_id_seq rename to jobs_id_seq;
EOF
  end

  def self.down
  end
end
