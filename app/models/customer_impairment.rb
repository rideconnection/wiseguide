class CustomerImpairment < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :customer
  belongs_to :impairment

  validates :impairment_id, :presence => true
  validates :notes, :length => {:maximum => 255}
end
