class SwitchCaseManagerStringToCaseManagerId < ActiveRecord::Migration
  def self.up
    add_column :kases, :case_manager_id, :integer
    CoachingKase.all.each do |kase|
      first_name, last_name = kase.case_manager.split(" ", 2) unless kase.case_manager.blank?
      u = User.find_by_first_name_and_last_name(first_name, last_name||"")
      if u
        kase.case_manager_id = u.id
        kase.save
      end
    end
    remove_column :kases, :case_manager
  end

  def self.down
    add_column :kases, :case_manager, :string
    CoachingKase.all.each do |kase|
      u = User.find(kase.case_manager_id)
      if u
        kase.case_manager = [u.first_name, u.last_name].compact.reject(&:blank?).join(" ")
        kase.save
      end
    end
    remove_column :kases, :case_manager_id
  end
end
