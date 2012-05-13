class AddIndexToKasesSchedulingSystemEntryRequired < ActiveRecord::Migration
  def change
    add_index :kases, :scheduling_system_entry_required
  end
end