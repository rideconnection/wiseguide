class TripAuthorization < ActiveRecord::Base
  stampable creator_attribute: :created_by_id, updater_attribute: :updated_by_id
  belongs_to :created_by, foreign_key: :created_by_id, class_name: 'User'
  belongs_to :updated_by, foreign_key: :updated_by_id, class_name: 'User'

  belongs_to :kase
  belongs_to :disposition_user, class_name: 'User'
  attr_accessible :allowed_trips_per_month, :disposition_date, :end_date,
    :disposition_user_id, :kase_id, :start_date
  validates :allowed_trips_per_month, numericality: { greater_than_or_equal_to: 0 }
  validates :start_date, timeliness: { :type => :date }
  validates :end_date, allow_blank: true, timeliness: { on_or_after: :start_date, :type => :date }
  validates :disposition_date, allow_blank: true, timeliness: { on_or_before: lambda { DateTime.current }, :type => :date }
  validates_presence_of :kase_id
  
  after_initialize do
    if self.new_record?
      self.start_date ||= Date.current
      self.allowed_trips_per_month ||= 1
    end
  end
  
  def complete_disposition(user)
    self.update_attributes!({
      disposition_date: DateTime.current,
      disposition_user_id: user.id
    })
  end
  
  def customer
    return kase.customer
  end
end
