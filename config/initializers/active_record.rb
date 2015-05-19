# Used by some STI magic methods

module ActiveRecord
  class Base
    def self.human_name
      self.model_name.underscore.humanize.titlecase
    end

    def self.humanized_name
      human_name
    end
  end
end
