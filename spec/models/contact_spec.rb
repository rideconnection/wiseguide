require 'spec_helper'

describe Contact do
  before do
    @contact = FactoryGirl.build(:contact)
  end
  
  it "should create a new instance given valid attributes" do
    @contact.valid?.should be_truthy
  end

  it "should require a valid description" do
    @contact.description = nil
    @contact.valid?.should be_falsey
    @contact.description = "A"
    @contact.valid?.should be_truthy
    @contact.description = "A" * 201
    @contact.valid?.should be_falsey
    @contact.description = "A" * 200
    @contact.valid?.should be_truthy
  end
  
  it "should require a valid date_time before or equal to the current time" do
    @contact.date_time = nil
    @contact.valid?.should be_falsey

    @contact.date_time = Time.current + 1.minute
    @contact.valid?.should be_falsey

    @contact.date_time = Time.current
    @contact.valid?.should be_truthy
  end
  
  describe "contactable_type" do
    it { should_not accept_values_for(:contactable_type, nil, "", "foo") }
    it { should accept_values_for(:contactable_type, "Customer", "Kase", "AssessmentRequest", "TrainingKase", "CoachingKase") }
  end
    
  context "associations" do
    describe "contactable" do
      before do
        @contact = FactoryGirl.build(:contact)
      end

      context "with a Customer" do      
        before do
          @customer = FactoryGirl.create(:customer)
          @contact.contactable_type = "Customer"
        end

        it "should require a valid association" do
          @contact.contactable_id = nil
          @contact.should_not be_valid

          @contact.contactable_id = ""
          @contact.should_not be_valid

          @contact.contactable_id = 0
          @contact.should_not be_valid

          @contact.contactable_id = 99
          @contact.should_not be_valid

          @contact.contactable_id = @customer.id
          @contact.should be_valid
        end

        it "should return the proper associated object" do
          @contact.contactable_id = @customer.id
          @contact.save
          @contact.contactable.should == @customer
        end
      end

      context "with a Kase" do      
        before do
          @kase = FactoryGirl.create(:training_kase)
          @contact.contactable_type = "TrainingKase"

          # We need to reload this to get the correct sub class
          @kase = Kase.find(@kase.id)
        end

        it "should require a valid association" do
          @contact.contactable_id = nil
          @contact.should_not be_valid

          @contact.contactable_id = ""
          @contact.should_not be_valid

          @contact.contactable_id = 0
          @contact.should_not be_valid

          @contact.contactable_id = 99
          @contact.should_not be_valid

          @contact.contactable_id = @kase.id
          @contact.should be_valid
        end

        it "should return the proper associated object" do
          @contact.contactable_id = @kase.id
          @contact.save
          @contact.contactable.should == @kase
        end
      end

      context "with an AssessmentRequest" do      
        before do
          @assessment_request = FactoryGirl.create(:assessment_request)
          @contact.contactable_type = "AssessmentRequest"
        end

        it "should require a valid association" do
          @contact.contactable_id = nil
          @contact.should_not be_valid

          @contact.contactable_id = ""
          @contact.should_not be_valid

          @contact.contactable_id = 0
          @contact.should_not be_valid

          @contact.contactable_id = 99
          @contact.should_not be_valid

          @contact.contactable_id = @assessment_request.id
          @contact.should be_valid
        end

        it "should return the proper associated object" do
          @contact.contactable_id = @assessment_request.id
          @contact.save
          @contact.contactable.should == @assessment_request
        end
      end
    end
  end
end