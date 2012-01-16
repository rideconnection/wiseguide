class AddActiveFlagToResources < ActiveRecord::Migration
  def self.up
    add_column :resources, :active, :boolean
  end

  def self.down
    delete_column :resources, :active
  end
end
