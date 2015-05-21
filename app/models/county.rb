class County < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates_presence_of :name

  default_scope order(:name)
end
