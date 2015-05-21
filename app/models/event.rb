class Event < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  # attr_protected :user_id

  belongs_to :kase
  has_one    :customer, :through => :kase
  belongs_to :user
  belongs_to :event_type
  belongs_to :funding_source

  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id
  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'

  validates_presence_of :kase_id
  validates_presence_of :user_id
  validates :date, :timeliness => { :on_or_before => lambda { Date.current }, :type => :date }
  validates_presence_of :event_type_id
  validates_presence_of :funding_source_id
  validates_numericality_of :duration_in_hours
  validates_presence_of :start_time
  validates_presence_of :end_time
  validates_presence_of :notes, :if => lambda { |e| e.event_type.try(:require_notes) }

  default_scope order(:date)
  scope :in_range, lambda { |date_range| where(:date => date_range) }

  def customer
    return kase.customer
  end

  def start_time
    read_attribute(:start_time).try :to_s, :just_time
  end

  def end_time
    read_attribute(:end_time).try :to_s, :just_time
  end

end
