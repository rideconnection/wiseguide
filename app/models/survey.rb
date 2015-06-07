# TODO Verify Strong Parameters after upgrading Surveyor to v1.5

class Survey < ActiveRecord::Base
  include Surveyor::Models::SurveyMethods

  scope :active, -> { where(inactive_at: nil) }
  scope :inactive, -> { where.not(inactive_at: nil) }
end
