class AddShowFullNotesToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :show_full_notes, :boolean, :default => false
  end

  def self.down
    remove_column :events, :show_full_notes
  end
end
