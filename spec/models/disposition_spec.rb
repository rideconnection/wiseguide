require 'spec_helper'

describe Disposition do
  it "should create a new instance given valid attributes" do
    # We could put this in a before block to take advantage of transactions,
    # but I prefer to explicitly state why we are building a new object, 
    # especially since rebuilding it before each test is overkill, and
    # I can live with knowing I'm breaking convention here by destroying an
    # object from inside a test.
    valid = Factory(:disposition)
    valid.destroy
  end
  
  it "should allow a unique name within the scope of the subclass type" do
    Disposition.descendants.each do |disposition|
      Factory(disposition.original_model_name.underscore.to_sym, :name => 'Foo')
    end
    
    Disposition.descendants.each do |disposition|
      duplicate = Factory.build(disposition.original_model_name.underscore.to_sym, :name => 'Foo')
      duplicate.valid?.should be_false
      duplicate.errors.keys.should include(:name)
      duplicate.errors[:name].should include("has already been taken")
      
      unique = Factory.build(disposition.original_model_name.underscore.to_sym, :name => 'Bar')
      unique.valid?.should be_true
    end
  end
end
