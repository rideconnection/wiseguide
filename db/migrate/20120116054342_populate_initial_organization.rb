# We deleted the original model file on 03-Feb-2012, so this is a 
# placeholder model just for the migration.
class OrganizationType < ActiveRecord::Base; end

class Organization < ActiveRecord::Base
  belongs_to :organization_type

  def is_outside_org?
    organization_type.name != 'Ride Connection Staff'
  end
end

# Create a Ride Connection organization if it doesn't exist.  Add all
# users to it.
class PopulateInitialOrganization < ActiveRecord::Migration
  def self.up
    ['Ride Connection Staff',
     'Government Body',
     'Case Management Organization',
    ].each do |name|
      OrganizationType.find_or_create_by(name: name)
    end
    type = OrganizationType.find_by_name('Ride Connection Staff')
    rc = Organization.find_or_initialize_by_name('Ride Connection', :organization_type_id => type.id)
    rc.save!(:validate => false) unless rc.persisted?

    User.all.each do |user|
      if user.organization.nil? then
        user.organization = rc
        user.save! :validate => false
      end   
    end
  end

  def self.down
  end
end
