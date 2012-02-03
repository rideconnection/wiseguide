# We've already deleted the original model file, so this is a 
# placeholder model just for the migration.
class OrganizationType < ActiveRecord::Base; end

class DropOrganizationTypesTable < ActiveRecord::Migration
  def self.up
    add_column :organizations, :organization_type, :string
    [['Ride Connection Staff',        'parent'],
     ['Government Body',              'government'],
     ['Case Management Organization', 'case_mgmt']
    ].each do |old_type_name, new_type_id|
      old_type = OrganizationType.find_by_name(old_type_name)
      Organization.where(:organization_type_id => old_type.id).update_all(:organization_type => new_type_id)
    end
    drop_table :organization_types
    remove_column :organizations, :organization_type_id
  end

  def self.down
    add_column :organizations, :organization_type_id, :integer
    create_table :organization_types do |t|
      t.string :name

      t.timestamps
    end
    [['Ride Connection Staff',        'parent'],
     ['Government Body',              'government'],
     ['Case Management Organization', 'case_mgmt']
    ].each do |old_type_name, new_type_id|
      old_type = OrganizationType.find_or_create_by_name(old_type_name)
      Organization.where(:organization_type => new_type_id).update_all(:organization_type_id => old_type.id)
    end
    remove_column :organizations, :organization_type    
  end
end
