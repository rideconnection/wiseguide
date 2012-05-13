class AddHideLabelToAnswers < ActiveRecord::Migration
  def self.up
    add_column :answers, :hide_label, :boolean
  end

  def self.down
    remove_column :answers, :hide_label
  end
end
