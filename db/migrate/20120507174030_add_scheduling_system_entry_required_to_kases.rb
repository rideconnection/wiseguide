class AddSchedulingSystemEntryRequiredToKases < ActiveRecord::Migration
  def change
    add_column :kases, :scheduling_system_entry_required, :boolean
  end
end
