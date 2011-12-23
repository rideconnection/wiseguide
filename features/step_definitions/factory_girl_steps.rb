# Original Source: https://gist.github.com/485974
# Updated on 2011-12-23 to use current version of http://github.com/thoughtbot/factory_girl/blob/master/lib/factory_girl/step_definitions.rb
# Original comments follow:
## Stolen from: http://github.com/thoughtbot/factory_girl/blob/master/lib/factory_girl/step_definitions.rb
## and slightly modified so that steps which create only a single record, save
## that record to an instance variable, so you can do things like:
##
##   Given I am logged in as an admin
##   And a post exists with a title of "Awesome Post"
##   When I go to the post
##   Then I should see "Awesome Post"
##   And I should see a link to edit the post
##
## Since the Given creates a @post instance, it can be referred to like this:
##
##   # paths.rb:
##   when /the post/
##     post_path(@post)
##
##   # post_steps.rb:
##   Then /^I should see a link to edit the post$/
##     page.should have_xpath("//a[@href=#{edit_post_path(@post)}]")
##   end
##
## This can make your steps a bit more brittle if you're not careful, but for
## me the trade-off for DRY, readable steps is worth it.
##
## Ideally I could require 'factory_girl/step_definitions.rb' and just
## redefine the steps I wanted to change, but that raises
## an ambiguous step error. Haven't figured out how to get around that yet.
## Oh well, in the meantime, I'm just dropping this in with the rest of my
## step definitions.

module FactoryGirlStepHelpers
  def convert_human_hash_to_attribute_hash(human_hash, associations = [])
    HumanHashToAttributeHash.new(human_hash, associations).attributes
  end

  class HumanHashToAttributeHash
    attr_reader :associations

    def initialize(human_hash, associations)
      @human_hash   = human_hash
      @associations = associations
    end

    def attributes(strategy = CreateAttributes)
      @human_hash.inject({}) do |attribute_hash, (human_key, value)|
        attributes = strategy.new(self, *process_key_value(human_key, value))
        attribute_hash.merge({ attributes.key => attributes.value })
      end
    end

    private

    def process_key_value(key, value)
      value = value.strip if value.is_a?(String)
      [key.downcase.gsub(' ', '_').to_sym, value]
    end

    class AssociationManager
      def initialize(human_hash_to_attributes_hash, key, value)
        @human_hash_to_attributes_hash = human_hash_to_attributes_hash
        @key   = key
        @value = value
      end

      def association
        @human_hash_to_attributes_hash.associations.detect {|association| association.name == @key }
      end

      def association_instance
        return unless association

        if attributes_hash = nested_attribute_hash
          factory.build_class.first(:conditions => attributes_hash.attributes(FindAttributes)) or
          FactoryGirl.create(association.factory, attributes_hash.attributes)
        end
      end

      private

      def factory
        FactoryGirl.factory_by_name(association.factory)
      end

      def nested_attribute_hash
        attribute, value = @value.split(':', 2)
        return if value.blank?

        HumanHashToAttributeHash.new({ attribute => value }, factory.associations)
      end
    end

    class AttributeStrategy
      attr_reader :key, :value, :association_manager

      def initialize(human_hash_to_attributes_hash, key, value)
        @association_manager = AssociationManager.new(human_hash_to_attributes_hash, key, value)
        @key   = key
        @value = value
      end
    end

    class FindAttributes < AttributeStrategy
      def initialize(human_hash_to_attributes_hash, key, value)
        super

        if association_manager.association
          @key = "#{@key}_id"
          @value = association_manager.association_instance.try(:id)
        end
      end
    end

    class CreateAttributes < AttributeStrategy
      def initialize(human_hash_to_attributes_hash, key, value)
        super

        if association_manager.association
          @value = association_manager.association_instance
        end
      end
    end
  end
end

World(FactoryGirlStepHelpers)

FactoryGirl.factories.each do |factory|
  factory.compile
  factory.human_names.each do |human_name|
    Given /^the following (?:#{human_name}|#{human_name.pluralize}) exists?:$/i do |table|
      factories = []
      table.hashes.each do |human_hash|
        attributes = convert_human_hash_to_attribute_hash(human_hash, factory.associations)
        factories << FactoryGirl.create(factory.name, attributes)
      end
      instance_variable_set("@#{factory.name.to_s.pluralize}", factories)
    end

    Given /^an? #{human_name} exists$/i do
      instance_variable_set("@#{factory.name.to_s}", FactoryGirl.create(factory.name))
    end

    Given /^(\d+) #{human_name.pluralize} exist$/i do |count|
      instance_variable_set("@#{factory.name.to_s.pluralize}", FactoryGirl.create_list(factory.name, count.to_i))
    end

    if factory.build_class.respond_to?(:columns)
      factory.build_class.columns.each do |column|
        human_column_name = column.name.downcase.gsub('_', ' ')
        Given /^an? #{human_name} exists with an? #{human_column_name} of "([^"]*)"$/i do |value|
          instance_variable_set("@#{factory.name.to_s}", FactoryGirl.create(factory.name, column.name => value))
        end

        Given /^(\d+) #{human_name.pluralize} exist with an? #{human_column_name} of "([^"]*)"$/i do |count, value|
          instance_variable_set("@#{factory.name.to_s.pluralize}", FactoryGirl.create_list(factory.name, count.to_i, column.name => value))
        end
      end
    end
  end
end
