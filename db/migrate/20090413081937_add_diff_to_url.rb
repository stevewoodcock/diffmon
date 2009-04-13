class AddDiffToUrl < ActiveRecord::Migration
  def self.up
    add_column :urls, :diff, :text
  end

  def self.down
    remove_column :urls, :diff
  end
end
