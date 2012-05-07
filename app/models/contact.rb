class Contact < ActiveRecord::Base
  belongs_to :kase
  belongs_to :customer
  belongs_to :user
  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id
  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'

  validates :description, :presence => true, :length => {:maximum => 200}
  validates :date_time, :date => { :before_or_equal_to => Proc.new {Time.current} }
  validates_presence_of :customer
  validates_associated :customer
  validate do |contact|
    contact.errors[:kase] << "must belong to the same customer" if !contact.kase.nil? and contact.kase.customer != contact.customer
  end

  default_scope order(:date_time)
end
