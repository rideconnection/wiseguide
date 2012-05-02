require 'spec_helper'

describe TrainingKaseDisposition do
  it "should create a new instance given valid attributes" do
    # We could put this in a before block to take advantage of transactions,
    # but I prefer to explicitly state why we are building a new object, 
    # especially since rebuilding it before each test is overkill, and
    # I can live with knowing I'm breaking convention here by destroying an
    # object from inside a test.
    valid = FactoryGirl.create(:training_kase_disposition)
    valid.destroy
  end
end
