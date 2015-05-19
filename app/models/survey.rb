# TODO Verify Strong Parameters after upgrading Surveyor to v1.5

class Survey < ActiveRecord::Base
  include Surveyor::Models::SurveyMethods
end
