# TODO Verify Strong Parameters after upgrading Surveyor to v1.5

class Survey < ActiveRecord::Base
  include Surveyor::Models::SurveyMethods

  scope :active, where(:inactive_at => nil)
  scope :inactive, where('inactive_at IS NOT NULL') # TODO update for Rails 4.0
end
