require 'spec_helper'

describe AssessmentRequest do
  before do
    @case_manager = FactoryGirl.create(:case_manager)
    
    @valid_attributes = {
      :customer_first_name => "FirstName",
      :customer_last_name  => "LastName",
      :customer_phone      => "555-555-5555",
      :submitter_id        => @case_manager.id
    }

    @valid_assessment_request = AssessmentRequest.new
    @valid_assessment_request.attributes = @valid_attributes
  end
  
  it "should create a new instance given valid attributes" do
    AssessmentRequest.new.valid?.should be_false
    @valid_assessment_request.valid?.should be_true
  end

  describe "customer_first_name" do
    it { should_not accept_values_for(:customer_first_name, nil, "") }
    it { should accept_values_for(:customer_first_name, "a") }
  end

  describe "customer_last_name" do
    it { should_not accept_values_for(:customer_last_name, nil, "") }
    it { should accept_values_for(:customer_last_name, "a") }
  end

  describe "customer_phone" do
    it { should_not accept_values_for(:customer_phone, nil, "") }
    it { should accept_values_for(:customer_phone, "a") }
  end

  describe "submitter_id" do
    # For some reason I cannot get accept_values_for to properly test values
    # that should not be accepted. So fall back to the old style tests
    
    it "should not allow nil values" do
      @valid_assessment_request.submitter_id = nil
      @valid_assessment_request.valid?.should be_false
      @valid_assessment_request.errors.keys.should include(:submitter)
    end

    it "should not allow blank values" do
      @valid_assessment_request.submitter_id = ""
      @valid_assessment_request.valid?.should be_false
      @valid_assessment_request.errors.keys.should include(:submitter)
    end

    it "should not allow an ID of 0" do
      @valid_assessment_request.submitter_id = 0
      @valid_assessment_request.valid?.should be_false
      @valid_assessment_request.errors.keys.should include(:submitter)
    end

    it "should not allow arbitrary IDs" do
      @valid_assessment_request.submitter_id = 9999
      @valid_assessment_request.valid?.should be_false
      @valid_assessment_request.errors.keys.should include(:submitter)
    end
    
    it "should allow valid user IDs" do
      @valid_assessment_request.submitter_id = @case_manager.id
      @valid_assessment_request.valid?.should be_true
    end
  end

  describe "assignee_id" do
    it { should accept_values_for(:assignee_id, nil, "", 0, 1) }
  end

  describe "customer_birth_date" do
    it { should accept_values_for(:customer_birth_date, nil, "", Date.today) }
  end

  describe "notes" do
    it { should accept_values_for(:notes, nil, "", "a") }
  end

  describe "kase_id" do
    it { should accept_values_for(:kase_id, nil, "", 0, 1) }
  end

  describe "customer_id" do
    it { should accept_values_for(:customer_id, nil, "", 0, 1) }
  end

  describe "reason_not_completed" do
    it { should_not accept_values_for(:reason_not_completed, "Foo") }
    it { should accept_values_for(:reason_not_completed, nil, "", "Could not reach", "Duplicate request") }
  end

  context "instance methods" do
    describe "display_name" do
      it "should return the customer first name and last name in reverse order, separated by a comma" do
        @valid_assessment_request.display_name.should eql("LastName, FirstName")
      end
    end
  
    describe "organization" do
      it "should return the organization of the submitter" do
        @valid_assessment_request.organization.should == @case_manager.organization
      end
    end
    
    describe "status" do
      before do
        @ar_no_reason_no_kase     = FactoryGirl.create(:assessment_request, :reason_not_completed => nil,   :kase_id => nil)
        @ar_no_reason_with_kase   = FactoryGirl.create(:assessment_request, :reason_not_completed => nil,   :kase_id => 1)
        @ar_with_reason_no_kase_1 = FactoryGirl.create(:assessment_request, :reason_not_completed => "Could not reach", :kase_id => nil)
        @ar_with_reason_no_kase_2 = FactoryGirl.create(:assessment_request, :reason_not_completed => "Duplicate request", :kase_id => nil)
        @ar_with_reason_with_kase = FactoryGirl.create(:assessment_request, :reason_not_completed => "Could not reach", :kase_id => 1)
      end
      
      it "should return \"Pending\" when reason_not_completed is blank and no training kase has been recorded" do
        @ar_no_reason_no_kase.status.should         == "Pending"
        @ar_no_reason_with_kase.status.should_not   == "Pending"
        @ar_with_reason_no_kase_1.status.should_not == "Pending"
        @ar_with_reason_no_kase_2.status.should_not == "Pending"
        @ar_with_reason_with_kase.status.should_not == "Pending"
      end      
      
      it "should return \"Not completed\" when reason_not_completed is not blank and no training kase has been recorded" do
        @ar_no_reason_no_kase.status.should_not     match /^Not completed \(.+\)$/
        @ar_no_reason_with_kase.status.should_not   match /^Not completed \(.+\)$/
        @ar_with_reason_no_kase_1.status.should     match /^Not completed \(Could not reach\)$/
        @ar_with_reason_no_kase_2.status.should     match /^Not completed \(Duplicate request\)$/
        @ar_with_reason_with_kase.status.should_not match /^Not completed \(.+\)$/
      end      
      
      it "should return \"Completed\" when a training kase has been recorded, regardless of the state of reason_not_completed" do
        @ar_no_reason_no_kase.status.should_not     == "Completed"
        @ar_no_reason_with_kase.status.should       == "Completed"
        @ar_with_reason_no_kase_1.status.should_not == "Completed"
        @ar_with_reason_no_kase_2.status.should_not == "Completed"
        @ar_with_reason_with_kase.status.should     == "Completed"
      end      
    end
  end
  
  context "associations" do
    describe "assignee association" do
      it "should have a assignee attribute" do
        AssessmentRequest.new.should respond_to(:assignee)
      end

      it "should return the assigned user object" do
        assignee = FactoryGirl.create(:user)
        @valid_assessment_request.assignee = assignee
        @valid_assessment_request.assignee.should == assignee
      end
    end
    
    describe "submitter association" do
      it "should have a submitter attribute" do
        AssessmentRequest.new.should respond_to(:submitter)
      end

      it "should return the submitting user object" do
        @valid_assessment_request.submitter.should == @case_manager
      end
    end
    
    describe "customer association" do
      before do
        @customer = FactoryGirl.create(:customer)
      end
      
      it "should have a customer attribute" do
        AssessmentRequest.new.should respond_to(:customer)
      end

      it "should return nil if no customer has been specified" do
        @valid_assessment_request.customer.should be_nil
      end

      it "should return the customer user object if one has been specified" do
        @valid_assessment_request.customer_id = @customer.id
        @valid_assessment_request.customer.should == @customer
      end
    end
    
    describe "kase association" do
      before do
        # Reload the factory object to pick up the proper STI type
        @kase = TrainingKase.find(FactoryGirl.create(:training_kase).id)
      end
      
      it "should have a kase attribute" do
        AssessmentRequest.new.should respond_to(:kase)
      end

      it "should return nil if no kase has been specified" do
        @valid_assessment_request.kase.should be_nil
      end

      it "should return the kase user object if one has been specified" do
        @valid_assessment_request.kase_id = @kase.id
        @valid_assessment_request.kase.should == @kase
      end
    end
    
    describe "referring_organization association" do
      before do
        # We can't reference this until the AssessmentRequest has been saved ,
        # presumably because the `has_one through` can't be calculated until
        # after the submitter association has been saved first. (???)
        @valid_assessment_request = FactoryGirl.create(:assessment_request, :submitter => @case_manager)
      end
      
      it "should have a referring_organization attribute" do
        AssessmentRequest.new.should respond_to(:referring_organization)
      end

      it "should return the submitting user's organization" do
        @valid_assessment_request.referring_organization.should == @case_manager.organization
      end
    end

    describe "attachment association" do
      before do
        # We won't have a valid attachment URL until after the 
        # AssessmentRequest has been saved, since the model ID is used to
        # calculate the path
        @valid_assessment_request = FactoryGirl.create(:assessment_request)
      end

      it "should have an attachment attribute" do
        AssessmentRequest.new.should respond_to(:attachment)
      end

      it "should return a Paperclip attachment object" do
        @valid_assessment_request.attachment.class.to_s.should == "Paperclip::Attachment"
      end

      it "should return the default Paperclip relative URL if no file has been attached" do
        @valid_assessment_request.attachment.to_s.should eq("/attachments/original/missing.png")
      end

      it "should return the relative URL to the attachment if a file has been attached" do
        @valid_assessment_request.attachment = File.open(Rails.root.join("spec", "support", "images", "0.5_mb.jpg"))
        @valid_assessment_request.attachment.to_s.should =~ /^\/assessment_requests\/#{@valid_assessment_request.id}\/download_attachment/
      end
    end
  end
  
  context "scopes" do
    describe "assigned_to" do
      # scope :assigned_to, lambda { |user| where(:assignee_id => user.id) }
      before do
        @user_1 = FactoryGirl.create(:user)
        @user_2 = FactoryGirl.create(:user)
        @user_3 = FactoryGirl.create(:user)
        
        @assessment_request_1 = FactoryGirl.create(:assessment_request, :assignee => @user_1)
        @assessment_request_2 = FactoryGirl.create(:assessment_request, :assignee => @user_2)
        @assessment_request_3 = FactoryGirl.create(:assessment_request, :assignee => @user_1)
        @assessment_request_4 = FactoryGirl.create(:assessment_request, :assignee => @user_2)
        @assessment_request_5 = FactoryGirl.create(:assessment_request, :assignee => @user_1)
        @assessment_request_6 = FactoryGirl.create(:assessment_request, :assignee => @user_3)
      end
    
      it "should have a assigned_to attribute" do
        AssessmentRequest.should respond_to(:assigned_to)
      end
    
      it "should return the assessment requests that are assigned to a given user" do
        AssessmentRequest.assigned_to(@user_1).should =~ [@assessment_request_1, @assessment_request_3, @assessment_request_5]
        AssessmentRequest.assigned_to(@user_2).should =~ [@assessment_request_2, @assessment_request_4]
      end
    
      it "should return the assessment requests that are assigned to an array of users" do
        AssessmentRequest.assigned_to([@user_1, @user_2]).should =~ [@assessment_request_1, @assessment_request_3, @assessment_request_5, @assessment_request_2, @assessment_request_4]
      end
    end
    
    describe "submitted_by" do
      # scope :submitted_by, lambda { |user| where(:submitter_id => user.id) }
      before do
        @user_1 = FactoryGirl.create(:user)
        @user_2 = FactoryGirl.create(:user)
        @user_3 = FactoryGirl.create(:user)
        
        @assessment_request_1 = FactoryGirl.create(:assessment_request, :submitter => @user_1)
        @assessment_request_2 = FactoryGirl.create(:assessment_request, :submitter => @user_2)
        @assessment_request_3 = FactoryGirl.create(:assessment_request, :submitter => @user_1)
        @assessment_request_4 = FactoryGirl.create(:assessment_request, :submitter => @user_2)
        @assessment_request_5 = FactoryGirl.create(:assessment_request, :submitter => @user_1)
        @assessment_request_6 = FactoryGirl.create(:assessment_request, :submitter => @user_3)
      end

      it "should have a submitted_by attribute" do
        AssessmentRequest.should respond_to(:submitted_by)
      end

      it "should return the assessment requests that were submitted by a given user" do
        AssessmentRequest.submitted_by(@user_1).should =~ [@assessment_request_1, @assessment_request_3, @assessment_request_5]
        AssessmentRequest.submitted_by(@user_2).should =~ [@assessment_request_2, @assessment_request_4]
      end

      it "should return the assessment requests that were submitted by an array of users" do
        AssessmentRequest.submitted_by([@user_1, @user_2]).should =~ [@assessment_request_1, @assessment_request_3, @assessment_request_5, @assessment_request_2, @assessment_request_4]
      end
    end
    
    describe "belonging_to" do
      # scope :belonging_to, lambda { |organization| joins(:organization).where("organizations.id = ?", organization.id) }
      before do
        @organization_1 = FactoryGirl.create(:organization)
        @organization_2 = FactoryGirl.create(:organization)
        @organization_3 = FactoryGirl.create(:organization)
        
        user_1 = FactoryGirl.create(:user, :organization => @organization_1)
        user_2 = FactoryGirl.create(:user, :organization => @organization_2)
        user_3 = FactoryGirl.create(:user, :organization => @organization_1)
        user_4 = FactoryGirl.create(:user, :organization => @organization_2)
        user_5 = FactoryGirl.create(:user, :organization => @organization_3)
        
        @assessment_request_1 = FactoryGirl.create(:assessment_request, :submitter => user_1)
        @assessment_request_2 = FactoryGirl.create(:assessment_request, :submitter => user_2)
        @assessment_request_3 = FactoryGirl.create(:assessment_request, :submitter => user_3)
        @assessment_request_4 = FactoryGirl.create(:assessment_request, :submitter => user_4)
        @assessment_request_5 = FactoryGirl.create(:assessment_request, :submitter => user_1)
        @assessment_request_6 = FactoryGirl.create(:assessment_request, :submitter => user_3)
        @assessment_request_7 = FactoryGirl.create(:assessment_request, :submitter => user_4)
        @assessment_request_8 = FactoryGirl.create(:assessment_request, :submitter => user_4)
        @assessment_request_9 = FactoryGirl.create(:assessment_request, :submitter => user_5)
      end

      it "should have a belonging_to attribute" do
        AssessmentRequest.should respond_to(:belonging_to)
      end

      it "should return the assessment requests that were submitted by users belonging to a given organization" do
        AssessmentRequest.belonging_to(@organization_1).should =~ [@assessment_request_1, @assessment_request_3, @assessment_request_5, @assessment_request_6]
        AssessmentRequest.belonging_to(@organization_2).should =~ [@assessment_request_2, @assessment_request_4, @assessment_request_7, @assessment_request_8]
      end

      it "should return the assessment requests that were submitted by users belonging to an array of organizations" do
        AssessmentRequest.belonging_to([@organization_1, @organization_2]).should =~ [@assessment_request_1, @assessment_request_3, @assessment_request_5, @assessment_request_6, @assessment_request_2, @assessment_request_4, @assessment_request_7, @assessment_request_8]
      end
    end
    
    describe "pending" do
      # "Pending" (reason_not_completed is blank and no associated TC case)
      # scope :pending, where("(reason_not_completed IS NULL OR reason_not_completed = '') AND (kase_id IS NULL OR kase_id <= 0)")
      before do
        kase = FactoryGirl.create(:kase)
        
        @assessment_request_1 = FactoryGirl.create(:assessment_request, :reason_not_completed => "Duplicate request", :kase => nil)
        @assessment_request_2 = FactoryGirl.create(:assessment_request, :reason_not_completed => "Duplicate request", :kase => kase)
        @assessment_request_3 = FactoryGirl.create(:assessment_request, :reason_not_completed => "Duplicate request", :kase => nil)
        @assessment_request_4 = FactoryGirl.create(:assessment_request, :reason_not_completed => nil,   :kase => kase)
        @assessment_request_5 = FactoryGirl.create(:assessment_request, :reason_not_completed => "",    :kase => nil)
        @assessment_request_6 = FactoryGirl.create(:assessment_request, :reason_not_completed => nil,   :kase => kase)
      end

      it "should have a pending attribute" do
        AssessmentRequest.should respond_to(:pending)
      end

      it "should return the assessment requests where both reason_not_completed and kase_id are blank" do
        AssessmentRequest.pending.should =~ [@assessment_request_5]
      end
    end

    describe "not_completed" do
      # "Not completed" (reason_not_completed is not blank)
      # scope :not_completed, where("reason_not_completed IS NOT NULL OR reason_not_completed > ''")
      before do
        @assessment_request_1 = FactoryGirl.create(:assessment_request, :reason_not_completed => "Duplicate request")
        @assessment_request_2 = FactoryGirl.create(:assessment_request, :reason_not_completed => "Duplicate request")
        @assessment_request_3 = FactoryGirl.create(:assessment_request, :reason_not_completed => "Duplicate request")
        @assessment_request_4 = FactoryGirl.create(:assessment_request, :reason_not_completed => nil)
        @assessment_request_5 = FactoryGirl.create(:assessment_request, :reason_not_completed => "")
        @assessment_request_6 = FactoryGirl.create(:assessment_request, :reason_not_completed => nil)
      end

      it "should have a not_completed attribute" do
        AssessmentRequest.should respond_to(:not_completed)
      end

      it "should return the assessment requests where reason_not_completed is not blank" do
        AssessmentRequest.not_completed.should =~ [@assessment_request_1, @assessment_request_2, @assessment_request_3]
      end
    end

    describe "completed" do
      # "Completed" (kase_id foreign key is not blank)
      # scope :completed, where("kase_id > 0")
      before do
        kase_1 = FactoryGirl.create(:kase)
        kase_2 = FactoryGirl.create(:kase)
        
        @assessment_request_1 = FactoryGirl.create(:assessment_request, :kase => nil)
        @assessment_request_2 = FactoryGirl.create(:assessment_request, :kase => kase_1)
        @assessment_request_3 = FactoryGirl.create(:assessment_request, :kase => nil)
        @assessment_request_4 = FactoryGirl.create(:assessment_request, :kase => kase_2)
        @assessment_request_5 = FactoryGirl.create(:assessment_request, :kase => nil)
        @assessment_request_6 = FactoryGirl.create(:assessment_request, :kase => kase_1)
      end

      it "should have a completed attribute" do
        AssessmentRequest.should respond_to(:completed)
      end

      it "should return the assessment requests where the kase_id is not blank" do
        AssessmentRequest.completed.should =~ [@assessment_request_2, @assessment_request_4, @assessment_request_6]
      end
    end
  end
end