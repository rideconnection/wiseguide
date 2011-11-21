class AddNotesRequiredFieldToEventTypes < ActiveRecord::Migration
  def self.up
    change_table :event_types do |t|
      t.boolean :require_notes, :default => false
    end
    EventType.update_all :require_notes => false
  end

  def self.down
    change_table :event_types do |t|
      t.remove :require_notes
    end
  end
end
