class AddStiTypeFieldToKases < ActiveRecord::Migration
  def self.up
    add_column :kases, :type, :string
    Kase.update_all :type => "TrainingKase"
  end

  def self.down
    remove_column :kases, :type
  end
end