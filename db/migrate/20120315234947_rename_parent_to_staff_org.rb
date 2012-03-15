class RenameParentToStaffOrg < ActiveRecord::Migration
  def self.up
    Organization.update_all "organization_type = 'staff'",
                            "organization_type = 'parent'"
  end

  def self.down
    Organization.update_all "organization_type = 'parent'",
                            "organization_type = 'staff'"
  end
end
