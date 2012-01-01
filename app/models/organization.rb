class Organization < ActiveRecord::Base
  belongs_to :organization_type

  validates_presence_of :organization_type
end
