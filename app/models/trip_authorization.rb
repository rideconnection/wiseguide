class TripAuthorization < ActiveRecord::Base
  has_paper_trail

  belongs_to :kase
  belongs_to :disposition_user, class_name: 'User'
  has_one    :customer, through: :kase
  has_one    :assessment_request, through: :kase

  validates :allowed_trips_per_month, numericality: { greater_than_or_equal_to: 0 }
  validates :start_date, timeliness: { type: :date }
  validates :end_date, allow_blank: true, timeliness: { on_or_after: :start_date, type: :date }
  validates :disposition_date, allow_blank: true, timeliness: { on_or_before: lambda { DateTime.current }, type: :date }
  validates_presence_of :kase_id

  scope :created_in_range, lambda { |date_range| where("trip_authorizations.created_at >= ? AND trip_authorizations.created_at < ?", date_range.begin, date_range.end) }
  scope :for_parent_org,   lambda { |org| joins(assessment_request: {referring_organization: :parent}).where("parents_organizations.id = ?", org) }

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

end
