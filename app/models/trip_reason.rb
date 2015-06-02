class TripReason < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_paper_trail
  
  has_many :outcomes, :dependent => :restrict
end
