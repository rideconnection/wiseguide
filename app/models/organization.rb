class Organization < ActiveRecord::Base
  belongs_to :parent, :class_name => "Organization"

  ORGANIZATION_TYPES = {
    :staff =>      {:id => "staff",      :name => "Staff Organization"},
    :government => {:id => "government", :name => "Government Body"},
    :case_mgmt =>  {:id => "case_mgmt",  :name => "Case Management Organization"}
  }

  validates_presence_of  :organization_type
  validates_inclusion_of :organization_type, :in => ORGANIZATION_TYPES.values.collect{|t| t[:id]}
  validates_presence_of  :parent, :if => :is_cmo?

  has_many :users, :dependent => :restrict
  has_many :children, :class_name => "Organization",
           :foreign_key => "parent_id", :dependent => :nullify

  def organization_type_name
    ORGANIZATION_TYPES[organization_type.to_sym][:name]
  end
  
  def is_cmo?
    organization_type == ORGANIZATION_TYPES[:case_mgmt][:id]
  end
  
  def is_outside_org?
    organization_type != ORGANIZATION_TYPES[:staff][:id]
  end

  def parent_name
    parent.nil? ? "None" : parent.name
  end

  # Get all the assessment requests that were submitted by this organization
  def assessment_requests
    AssessmentRequest.where(:submitter_id => all_users())
  end

  # Get all users that are in this organization or a child organization
  def all_users
    User.where(:organization_id => self.children << self)
  end
end
