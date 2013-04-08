class TripAuthorization < ActiveRecord::Base
  belongs_to :user
  belongs_to :disposition_user, class_name: :user
  attr_accessible :allowed_trip_per_month, :disposition_date, :end_date,
    :user_id, :disposition_user_id
  validates_presence_of :allowed_trip_per_month, :disposition_date, :user_id,
    :disposition_user_id
  validates :allowed_trip_per_month, numericality: { greater_than_or_equal_to: 1 }
end
