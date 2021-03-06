module DevelopmentKaseBehavior
  def self.included(base_class)
    base_class.class_eval do

      # NOTE: We moved the model associations out of this mixin.  Although they 
      # do work here, the database-level relations still exist no matter what 
      # subclass, so it's more consistent and less error-prone to just add those
      # associations for all models, but only do validations when needed.
      
      validates_presence_of :referral_type_id
      validates             :household_income,     numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
      validates             :household_size,       numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
      validates             :adult_ticket_count,   numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
      validates             :honored_ticket_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
      validates             :household_income_alternate_response, inclusion: { :in => %w( Unknown Refused ) }, allow_blank: true
      validates             :household_size_alternate_response,   inclusion: { :in => %w( Unknown Refused ) }, allow_blank: true
      validate do |kase|
        kase.errors[:household_income] << "is required" if kase.household_income.blank? && kase.household_income_alternate_response.blank?
        kase.errors[:household_size] << "is required" if kase.household_size.blank? && kase.household_size_alternate_response.blank?
      end
      
      before_save :cleanup_household_stats
      
      scope :for_funding_source_id, lambda {|funding_source_id| funding_source_id.present? ? where(funding_source_id: funding_source_id) : where(nil) }
    end
  end
  
  def cleanup_household_stats
    self.household_income = nil if !self.household_income_alternate_response.blank?
    self.household_size = nil if !self.household_size_alternate_response.blank?
  end
end
