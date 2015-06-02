class Customer < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :ethnicity
  belongs_to :ada_service_eligibility_status
  
  has_many :assessment_requests
  has_many :customer_impairments, :dependent => :destroy
  has_many :impairments, :through => :customer_impairments
  has_many :kases, :dependent => :restrict
  has_many :contacts, :as => :contactable, :dependent => :destroy
  has_many :customer_support_network_members, :dependent => :destroy

  has_attached_file :portrait, 
    :styles => { :small => "250", :original => "1200x1200" },
    :path   => ":rails_root/uploads/:attachment/:id/:style/:basename.:extension",
    :url    => "/customers/:id/download_:style_portrait"

  validates_attachment_content_type :portrait, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/pjpeg']

  validates_presence_of :ethnicity_id
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates             :birth_date, :timeliness => { :before => Proc.new { Date.current }, :type => :date }
  validates_presence_of :gender
  validates_presence_of :phone_number_1
  validates_format_of   :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, :allow_blank => true
  validates_presence_of :address
  validates_presence_of :city
  validates_length_of   :state, :is => 2
  validates_format_of   :zip, :with => %r{\d{5}(-\d{4})?}, :message => "should be 12345 or 12345-6789" 
  validates_presence_of :county
  validates             :middle_initial, :length => { :maximum => 1 }

  HUMAN_ATTRIBUTE_NAMES = {
    :veteran_status => "Veteran?",
    :spouse_of_veteran_status => "Spouse, widow, or widower of a veteran?",
    :honored_citizen_cardholder => "Honored citizen cardholder?",
    :ada_service_eligibility_status_id => "TriMet Lift Eligibity status"
  }
  
  def self.human_attribute_name(attr, options={})
    HUMAN_ATTRIBUTE_NAMES[attr.to_sym] || super
  end

  # TODO wut?
  scope :empty, lambda { where ("1 = 2") }

  cattr_reader :per_page
  @@per_page = 50

  include ActiveSupport::Rescuable
  
  scope :with_successful_exit_in_range_for_county, lambda{|start_date,end_date,county_code| where("customers.id IN (SELECT customer_id FROM kases WHERE disposition_id IN (?) AND close_date BETWEEN ? AND ? AND county = ?)",Disposition.successful.collect(&:id),start_date,end_date,county_code)}

  def self.with_new_successful_exit_in_range_for_county(start_date,end_date,county_code)
    fy_start_date = Date.new(start_date.year - (start_date.month < 7 ? 1 : 0), 7, 1)
    self.with_successful_exit_in_range_for_county(start_date,end_date,county_code).where("customers.id NOT IN (SELECT customer_id FROM kases WHERE disposition_id IN (?) AND close_date BETWEEN ? AND ? AND county = ?)",Disposition.successful.collect(&:id),fy_start_date,start_date - 1.day,county_code)
  end

  def self.search(term)
    return empty if term.nil?
    Rails.logger.debug('Search term "%s" was received' % term)
    term = term.gsub(/[^\w\s,]/i, '').lstrip
    if term.match /^\w+\s+$/i
      # Given a single word followed by a space
      # Then search for a complete first_name match
      term = term.strip
      query, args = make_customer_name_query("first_name", term, :complete)
      Rails.logger.debug('Search term "%s" matched pattern "%s"' % [term, '^\w+\s+$'])
    elsif term.match /^\w+,\s*$/i
      # Given a single word followed by a comma
      # Then search for a complete last_name match
      term = term.gsub(",", "").strip
      query, args = make_customer_name_query("last_name", term, :complete)
      Rails.logger.debug('Search term "%s" matched pattern "%s"' % [term, '^\w+,\s*$'])
    elsif term.match /^\w+\s+\w+\s*$/i
      # Given a word followed by a space followed by at least one word character
      # Then search for a complete first name match and a last name that begins with the second set of characters
      first_name, last_name = term.split(" ").map(&:strip)
      query, args = make_customer_name_query("first_name", first_name, :complete)
      lnquery, lnargs = make_customer_name_query("last_name", last_name)
      query += " and " + lnquery 
      args += lnargs
      Rails.logger.debug('Search term "%s" matched pattern "%s"' % [term, '^\w+\s+\w+\s*$'])
    elsif term.match /^\w+,\s*\w+\s*/i
      # Given a word followed by a comma followed by an optional space followed by at least one word character
      # Then search for a complete last name match and a first name that begins with the second set of characters
      last_name, first_name = term.split(",").map(&:strip)
      query, args = make_customer_name_query("last_name", last_name, :complete)
      fnquery, fnargs = make_customer_name_query("first_name", first_name)
      query += " and " + fnquery
      args += fnargs
      Rails.logger.debug('Search term "%s" matched pattern "%s"' % [term, '^\w+,\s*\w+\s*$'])
    elsif term.match(/^\w+$/i)
      # Given at least one word character with no trailing whitespace
      # Then search for a first name or a last name that begins with the term
      term = term.strip
      query, args = make_customer_name_query("first_name", term)
      lnquery, lnargs = make_customer_name_query("last_name", term)
      query += " or " + lnquery
      args += lnargs
      Rails.logger.debug('Search term "%s" matched pattern "%s"' % [term, '^\w+$'])
    elsif term.strip.blank?
      # Given a search term that contains only whitespace
      # Then return all rows      
      query = ''
      args = []
      Rails.logger.debug 'Search term was empty'
    else
      # Given a search term that does not match any of the rules above (e.g. it contains non-word characters)
      # Then return nothing
      Rails.logger.debug "Search term could not be matched with a known search rule: #{term}"
      return empty
    end

    Rails.logger.debug "QUERY: #{query}"
    Rails.logger.debug "QUERY: #{args}"

    conditions = [query] + args
    Rails.logger.debug "QUERY: #{conditions}"
    # raise "#{conditions}"
    case ActiveRecord::Base.connection.adapter_name
      # With SQLite, do not attempt metaphone queries (unsupported)
      when "SQLite"
        empty
      else
        Customer.where(conditions)
    end
  end
  
  def self.make_customer_name_query(field, value, option=nil)
    value = value.downcase
    if option == :initial
      return "(LOWER(%s) = ?)" % field, [value]
    elsif option == :complete
      return "(LOWER(%s) = ? or 
dmetaphone(%s) = dmetaphone(?) or 
dmetaphone(%s) = dmetaphone_alt(?)  or
dmetaphone_alt(%s) = dmetaphone(?) or 
dmetaphone_alt(%s) = dmetaphone_alt(?))" % [field, field, field, field, field], [value, value, value, value, value]
    else
      like = value + "%"

      return "(LOWER(%s) like ? or 
dmetaphone(%s) LIKE dmetaphone(?) || '%%' or 
dmetaphone(%s) LIKE dmetaphone_alt(?)  || '%%' or
dmetaphone_alt(%s) LIKE dmetaphone(?)  || '%%'or 
dmetaphone_alt(%s) LIKE dmetaphone_alt(?) || '%%')" % [field, field, field, field, field], [like, value, value, value, value]

    end
  end

  def name
    return "%s %s" % [first_name, last_name]
  end
  
  def name_reversed
    return "%s, %s" % [last_name, first_name]
  end

  def age_in_years
    if birth_date.nil?
      return nil
    end
    today = Date.current
    years = today.year - birth_date.year #2011 - 1980 = 31
    if today.month < birth_date.month  || today.month == birth_date.month and today.day < birth_date.day #but 4/8 is before 7/3, so age is 30
      years -= 1
    end
    return years
  end

  def veteran_status_description
    if veteran_status.nil?
      "Not asked"
    else 
      veteran_status ? "Yes" : "No"
    end
  end

end
