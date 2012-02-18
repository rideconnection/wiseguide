class AddStiKindFieldToDispositions < ActiveRecord::Migration
  def self.up
    add_column :dispositions, :type, :string
    add_index :dispositions, :type
    add_index :dispositions, [:name, :type], :unique => true
    add_index :kases, :type
    Disposition.update_all :type => "TrainingKase"
  end

  def self.down
    remove_index :kases, :type
    remove_index :dispositions, :column => [:name, :type]
    remove_index :dispositions, :type
    remove_column :dispositions, :type
  end
end