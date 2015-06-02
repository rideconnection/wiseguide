class Disposition < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_paper_trail
  
  validates :name, :uniqueness => {:scope => :type}
  validate do |disposition|
    disposition.errors[:type] << "must be a valid subclass of Disposition" unless Disposition.descendants.map{|disposition| disposition.original_model_name}.include?(disposition.type)
  end

  def self.successful
    self.where(:name => 'Successful')
  end
  
  # Make sure our STI children are routed through the parent routes
  def self.inherited(child)
    child.instance_eval do      
      alias :original_model_name :model_name
            
      def model_name
        Disposition.model_name
      end
      
      def human_name
        self.original_model_name.underscore.humanize.titlecase
      end
      
      def humanized_name
        human_name.sub(/\bKase\b/, 'Case')
      end
    end
    super
  end
end
