class Contact < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :user
  belongs_to :contactable, polymorphic: true

  validates :description, presence: true, length: {maximum: 200}
  validates :date_time, timeliness: { on_or_before: lambda { Time.current }, type: :datetime }
  validates :contactable_type, inclusion: { :in => %w(AssessmentRequest Customer Kase CoachingKase CustomerServiceKase TrainingKase) }
  validates :contactable, presence: true, associated: { message: "The associated object (Customer, Case, or Assessment Request) is invalid" }

  default_scope { order(:date_time) }
end
