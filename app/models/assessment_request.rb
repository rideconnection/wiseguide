class AssessmentRequest < ActiveRecord::Base
  belongs_to :submitter, :class_name => "User", :foreign_key => :submitter_id

  validates_presence_of :customer_first_name
  validates_presence_of :customer_last_name
  validates_presence_of :customer_phone
  validates_presence_of :submitter

  attr_accessible :customer_first_name, :customer_last_name,
                  :customer_birth_date, :customer_phone, :notes,
                  :submitter, :submitter_id
end
