class Organization < ActiveRecord::Base
  belongs_to :parent, :class_name => "Organization"

  ORGANIZATION_TYPES = {
    :staff =>      {:id => "staff",      :name => "Staff Organization"},
    :government => {:id => "government", :name => "Government Body"},
    :case_mgmt =>  {:id => "case_mgmt",  :name => "Case Management Organization"}
  }

  validates_presence_of :name
  validates_presence_of  :organization_type
  validates_inclusion_of :organization_type, :in => ORGANIZATION_TYPES.values.collect{|t| t[:id]}
  validate :validate_parent

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

  def validate_parent
    case organization_type
    when ORGANIZATION_TYPES[:staff][:id], ORGANIZATION_TYPES[:government][:id]
      unless parent_id.nil? || parent_id == 0
        errors.add_to_base("#{organization_type_name} cannot have a parent.")
      end
    when ORGANIZATION_TYPES[:case_mgmt][:id]
      if parent_id.nil? || parent_id == 0
        errors.add_to_base("#{organization_type_name} must have a parent.")
      elsif parent.organization_type != ORGANIZATION_TYPES[:government][:id]
        errors.add_to_base("Parent organization must be a " +
            "#{ORGANIZATION_TYPES[:government][:name]}")
      end
    end
  end

end
