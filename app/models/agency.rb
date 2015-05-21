class Agency < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  # attr_accessible :name

  validates_presence_of :name
  default_scope order(:name)
end
