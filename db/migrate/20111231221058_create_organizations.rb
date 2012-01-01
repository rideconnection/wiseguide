class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name
      t.integer :organization_type_id
      t.integer :parent_id, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :organizations
  end
end
