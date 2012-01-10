class Organization < ActiveRecord::Base
  belongs_to :organization_type
  belongs_to :parent, :class_name => "Organization"

  validates_presence_of :organization_type
  validates_presence_of :parent, :if => :is_cmo?

  has_many :children, :class_name => "Organization",
           :foreign_key => "parent_id", :dependent => :nullify

  def is_cmo?
    organization_type.name == 'Case Management Organization'
  end

  def parent_name
    parent.nil? ? "None" : parent.name
  end
end
