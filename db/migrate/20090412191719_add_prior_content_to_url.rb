class AddPriorContentToUrl < ActiveRecord::Migration
  def self.up
    add_column :urls, :prior_content, :text
  end

  def self.down
    remove_column :urls, :prior_content
  end
end
