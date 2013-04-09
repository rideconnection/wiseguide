class TripAuthorization < ActiveRecord::Base
  stampable creator_attribute: :created_by_id, updater_attribute: :updated_by_id
  belongs_to :created_by, foreign_key: :created_by_id, class_name: 'User'
  belongs_to :updated_by, foreign_key: :updated_by_id, class_name: 'User'

  belongs_to :disposition_user, class_name: 'User'
  attr_accessible :allowed_trips_per_month, :disposition_date, :end_date,
    :disposition_user_id
  validates :allowed_trips_per_month, numericality: { greater_than_or_equal_to: 1 }
  validates :end_date, allow_blank: true, date: { after_or_equal_to: Proc.new { Date.current } }
  validates :disposition_date, allow_blank: false, date: { before_or_equal_to: Proc.new { DateTime.current } }
  validates_presence_of :disposition_user_id
  
  after_initialize do
    if self.new_record?
      self.allowed_trips_per_month ||= 1
    end
  end
end
