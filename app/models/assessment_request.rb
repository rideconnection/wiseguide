class AssessmentRequest < ActiveRecord::Base
  belongs_to :submitter, :class_name => "User", :foreign_key => :submitter_id
  belongs_to :customer
  belongs_to :kase

  has_attached_file :attachment,
    :path => ":rails_root/uploads/:attachment/:id/:basename.:extension",
    :url  => "/assessment_requests/:id/download_attachment"

  validates_attachment_content_type :attachment,
    :content_type => ['application/pdf']

  validates_presence_of :customer_first_name
  validates_presence_of :customer_last_name
  validates_presence_of :customer_phone
  validates_presence_of :submitter

  attr_accessible :attachment, :customer_first_name, :customer_last_name,
                  :customer_birth_date, :customer_phone, :notes,
                  :submitter, :submitter_id

  def display_name
    return customer_last_name + ", " + customer_first_name
  end
  
  def organization
    return submitter.organization
  end
end
