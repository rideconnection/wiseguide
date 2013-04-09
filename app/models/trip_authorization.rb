class TripAuthorization < ActiveRecord::Base
  belongs_to :user
  belongs_to :disposition_user, class_name: :User
  attr_accessible :allowed_trips_per_month, :disposition_date, :end_date,
    :user_id, :disposition_user_id
  validates :allowed_trips_per_month, numericality: { greater_than_or_equal_to: 1 }
  validates :end_date, allow_blank: true, date: { after_or_equal_to: Proc.new { Date.current } }
  validates :disposition_date, allow_blank: false, date: { before_or_equal_to: Proc.new { DateTime.current } }
  validates_presence_of :user_id, :disposition_user_id
  
  after_initialize do
    if self.new_record?
      self.allowed_trips_per_month ||= 1
    end
  end
end
