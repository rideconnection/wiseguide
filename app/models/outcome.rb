class Outcome < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_paper_trail
  
  belongs_to :kase
  belongs_to :trip_reason

  validates_presence_of :kase_id
  validates_presence_of :trip_reason_id
  validates_presence_of :exit_trip_count
  validates_presence_of :exit_vehicle_miles_reduced
  
  def customer
    return kase.customer
  end
end
