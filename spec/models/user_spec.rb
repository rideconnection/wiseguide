require 'spec_helper'

describe User do
  before do
    @staff_organization = FactoryGirl.create(:staff_organization)
    @government_organization = FactoryGirl.create(:government_organization)
    @case_mgmt_organization = FactoryGirl.create(:case_mgmt_organization)
    
    @valid_attributes = {
      :first_name            => "FirstName",
      :last_name             => "LastName",
      :organization_id       => @staff_organization.id,
      :email                 => "firstname.lastname@example.com",
      :password              => "password 1",
      :password_confirmation => "password 1"
    }

    @valid_user = User.new
    @valid_user.attributes = @valid_attributes
  end
  
  it "should create a new instance given valid attributes" do
    User.new.valid?.should be_falsey
    @valid_user.valid?.should be_truthy
  end

  describe "first_name" do
    it { should_not accept_values_for(:first_name, nil, "") }
    it { should accept_values_for(:first_name, "a") }
  end

  describe "last_name" do
    it { should_not accept_values_for(:last_name, nil, "") }
    it { should accept_values_for(:last_name, "a") }
  end

  describe "email" do
    it { should_not accept_values_for(:email, nil, "") } 
    it { should_not accept_values_for(:email, "a") }
    it { should_not accept_values_for(:email, "a@b.c") }
    
    it { should accept_values_for(:email, "a@b.cd") }
    it { should accept_values_for(:email, ("a" * 95) + "@b.cd") }
    
    describe "uniqueness" do
      before do
        FactoryGirl.create(:user, :email => 'z@y.xw')
        @duplicate = FactoryGirl.build(:user, :email => 'z@y.xw')
      end
      
      it "should be unique" do
        @duplicate.should_not be_valid
        @duplicate.errors[:email].should include("has already been taken")
      end
    end
  end

  describe "organization_id" do
    it { should accept_values_for(:organization_id, 0, 1) }
    it { should_not accept_values_for(:organization_id, nil, "") }
  end

  describe "phone_number" do
    it { should accept_values_for(:phone_number, nil, "", "5", "A", "555-FON-4FUN") }
  end

  describe "password" do
    # must be 8 - 20 characters in length and have at least one number and at least one non-alphanumeric character
    it { should_not accept_values_for(:password, nil, "") }    
    it { should_not accept_values_for(:password, "aaaaaaaa") }
    it { should_not accept_values_for(:password, "aaaa1234") }
    it { should_not accept_values_for(:password, "aaa  aaa") }
    it { should_not accept_values_for(:password, "1-----1") }
    it { should_not accept_values_for(:password, "aaa 123") }
    it { should_not accept_values_for(:password, "aaaaaaaaaaaaaaa") }
    it { should_not accept_values_for(:password, "aaaaaaaaaaaaaaaaaaa 1") }
    
    it { should accept_values_for(:password, "aaaaaa 1") }
    it { should accept_values_for(:password, "aaa_1234") }
    it { should accept_values_for(:password, "1------1") }
    it { should accept_values_for(:password, "aaaa 123") }
    it { should accept_values_for(:password, "11111111111111      ") }
    it { should accept_values_for(:password, "aaaaaaaaaaaaaaaaaa 1") }
  end

  context "instance methods" do
    before do
      @valid_user = FactoryGirl.create(:user, :first_name => "FirstName", :last_name => "LastName")
    end
    
    describe "display_name" do
      it "should return the full name when both first_name and last_name are populated" do
        @valid_user.display_name.should eql("FirstName LastName")
      end
    
      it "should return only the last name when the first_name is blank and the last_name is populated" do
        # with only a last name
        @valid_user.first_name = nil
        @valid_user.last_name  = "LastName"
        @valid_user.display_name.should eql("LastName")
      end
    
      it "should return only the first name when the first_name is populated and the last_name is blank" do
        # with only a first name
        @valid_user.first_name = "FirstName"
        @valid_user.last_name  = nil
        @valid_user.display_name.should eql("FirstName")
      end
    
      it "should return \"Unnamed User\" when both the first_name and last_name are blank" do
        # with neither name
        @valid_user.first_name = nil
        @valid_user.last_name = nil
        @valid_user.display_name.should eql("Unnamed User")
      end
    end
  
    describe "role_name" do
      it "should return \"Deleted\" when the user level is -1" do
        @valid_user.level = -1
        @valid_user.role_name.should eql("Deleted")
      end
      
      it "should return \"Viewer\" when the user level is 0" do
        @valid_user.level = 0
        @valid_user.role_name.should eql("Viewer")
      end
      
      it "should return \"Outside\" when the user level is 25" do
        @valid_user.level = 25
        @valid_user.role_name.should eql("Outside")
      end
      
      it "should return \"Editor\" when the user level is 50" do
        @valid_user.level = 50
        @valid_user.role_name.should eql("Editor")
      end
      
      it "should return \"Admin\" when the user level is 100" do
        @valid_user.level = 100
        @valid_user.role_name.should eql("Admin")
      end
    end
  
    describe "is_admin" do
      it "should return false when the user level is -1" do
        @valid_user.level = -1
        @valid_user.is_admin.should be_falsey
      end
      
      it "should return false when the user level is 0" do
        @valid_user.level = 0
        @valid_user.is_admin.should be_falsey
      end
      
      it "should return false when the user level is 25" do
        @valid_user.level = 25
        @valid_user.is_admin.should be_falsey
      end
      
      it "should return false when the user level is 50" do
        @valid_user.level = 50
        @valid_user.is_admin.should be_falsey
      end
      
      it "should return true when the user level is 100" do
        @valid_user.level = 100
        @valid_user.is_admin.should be_truthy
      end      
    end
  
    describe "is_outside_user?" do
      it "should return false when the parent organization is a staff organization" do
        @valid_user.organization = @staff_organization
        @valid_user.is_outside_user?.should be_falsey
      end
      
      it "should return true when the parent organization is a government organization" do
        @valid_user.organization = @government_organization
        @valid_user.is_outside_user?.should be_truthy
      end
      
      it "should return true when the parent organization is a case management organization" do
        @valid_user.organization = @case_mgmt_organization
        @valid_user.is_outside_user?.should be_truthy
      end
    end
  
    describe "update_password" do
      before do
        @valid_user = FactoryGirl.create(:user, :password => "password 1")
      end
      
      it "should return false when both params are blank" do
        @valid_user.update_password(
          {:password => "", :password_confirmation => "", :current_password => "password 1"}
        ).should be_falsey
      end
      
      it "should return false when the password_confirmation param is blank" do
        @valid_user.update_password(
          {:password => "asdf", :password_confirmation => "", :current_password => "password 1"}
        ).should be_falsey
      end
      
      it "should return false when both params are populated and match but aren't valid" do
        @valid_user.update_password(
          {:password => "asdf", :password_confirmation => "asdf", :current_password => "password 1"}
        ).should be_falsey
      end
      
      it "should return false both params are populated and valid, but don't match" do
        @valid_user.update_password(
          {:password => "aaaaaa 1", :password_confirmation => "aaaaaa 2", :current_password => "password 1"}
        ).should be_falsey
      end
      
      it "should return true when both params are populated, match and are valid, and the current password is correct" do
        @valid_user.update_password(
          {:password => "aaaaaa 1", :password_confirmation => "aaaaaa 1", :current_password => "password 1"}
        ).should be_truthy
      end
      
      it "should return false when both params are populated, match and are valid, but the current password is wrong" do
        @valid_user.update_password(
          {:password => "aaaaaa 1", :password_confirmation => "aaaaaa 1", :current_password => "password 2"}
        ).should be_falsey
      end
    end
  end
  
  context "class methods" do
    describe "random_password" do
      it "should consistently return a random valid password" do
        # Ensure we are starting with a valid user
        @valid_user.valid?.should be_truthy
        
        100.times do
          password = User.random_password
          @valid_user.password = @valid_user.password_confirmation = password
          @valid_user.valid?.should be_truthy
        end
      end
    end
  end
  
  context "associations" do
    # TODO
    # has_many :kases, :dependent => :nullify
    # has_many :contacts, :dependent => :nullify
    # has_many :events, :dependent => :nullify
    # has_many :assessment_requests, :foreign_key => :submitter_id, :dependent => :nullify
    # has_many :referred_kases, :through => :assessment_requests, :source => :kase
    
    # describe "kases association" do
    # end
  end
end