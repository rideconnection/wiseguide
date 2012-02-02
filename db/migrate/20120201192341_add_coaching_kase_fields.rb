class AddCoachingKaseFields < ActiveRecord::Migration
  def self.up
    add_column :kases, :assessment_date, :date
    add_column :kases, :assessment_language, :string
    add_column :kases, :case_manager, :string
    add_column :kases, :case_manager_notification_date, :date
  end

  def self.down
    remove_column :kases, :case_manager_notification_date
    remove_column :kases, :case_manager
    remove_column :kases, :assessment_language
    remove_column :kases, :assessment_date
  end
end