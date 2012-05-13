require 'spec_helper'

describe Customer do
  before do
    @customer = FactoryGirl.build(:customer)
  end
  
  it "should create a new instance given valid attributes" do
    @customer.valid?.should be_true
  end
  
  describe "veteran_status" do
    it "should allow true" do
      @customer.veteran_status = true
      @customer.valid?.should be_true
    end

    it "should allow false" do
      @customer.veteran_status = false
      @customer.valid?.should be_true
    end

    it "should allow nil" do
      @customer.veteran_status = nil
      @customer.valid?.should be_true
    end
  end
  
  describe "spouse_of_veteran_status" do
    it "should allow true" do
      @customer.spouse_of_veteran_status = true
      @customer.valid?.should be_true
    end

    it "should allow false" do
      @customer.spouse_of_veteran_status = false
      @customer.valid?.should be_true
    end

    it "should allow nil" do
      @customer.spouse_of_veteran_status = nil
      @customer.valid?.should be_true
    end
  end
  
  describe "honored_citizen_cardholder" do
    it "should allow true" do
      @customer.honored_citizen_cardholder = true
      @customer.valid?.should be_true
    end

    it "should allow false" do
      @customer.honored_citizen_cardholder = false
      @customer.valid?.should be_true
    end

    it "should allow nil" do
      @customer.honored_citizen_cardholder = nil
      @customer.valid?.should be_true
    end
  end
  
  describe "primary_language" do
    it "should allow a text value" do
      @customer.primary_language = "A"
      @customer.valid?.should be_true
    end

    it "should allow nil" do
      @customer.primary_language = nil
      @customer.valid?.should be_true
    end
  end
  
  describe "ada_service_eligibility_status_id" do
    before do
      @ada_service_eligibility_status = FactoryGirl.create(:ada_service_eligibility_status)
    end
    
    it "should allow an integer value" do
      @customer.ada_service_eligibility_status_id = @ada_service_eligibility_status.id
      @customer.valid?.should be_true
    end

    it "should allow nil" do
      @customer.ada_service_eligibility_status_id = nil
      @customer.valid?.should be_true
    end    
  end
  
  describe "associations" do
    it "should have a ada_service_eligibility_status attribute" do
      @customer.should respond_to(:ada_service_eligibility_status)
    end
  end
  
  describe "search" do
    if connection_supports_dmetaphone?
      before(:all) do
        FactoryGirl.create(:customer, :first_name => "Donna",       :last_name => "Roberts")
        FactoryGirl.create(:customer, :first_name => "Jennifer",    :last_name => "Donnings")
        FactoryGirl.create(:customer, :first_name => "Robert",      :last_name => "Bradley Sr.")
        FactoryGirl.create(:customer, :first_name => "Bobby",       :last_name => "O'Brady")
        FactoryGirl.create(:customer, :first_name => "Bradley",     :last_name => "Srocco")
        FactoryGirl.create(:customer, :first_name => "Don",         :last_name => "Bobson")
        FactoryGirl.create(:customer, :first_name => "Bob",         :last_name => "Bradley")
        FactoryGirl.create(:customer, :first_name => "Christopher", :last_name => "Carlson")
        FactoryGirl.create(:customer, :first_name => "Brady",       :last_name => "Robert")
        FactoryGirl.create(:customer, :first_name => "Don",         :last_name => "Bradley")
      end
    
      after(:all) do
        Customer.destroy_all
      end
    
      # FYI - The results for these searches may not seem predictable when run
      # against a Postgres data source because we will be relying on a 
      # dmetaphone phonetic algorithm to do "fuzzy matching", similar to a 
      # soundex search. When in doubt, run the search manually and copy the 
      # results in to the expected results...

      it "should search for a complete first_name match given a single word followed by a space" do
        Customer.search("bob ").collect(&:name_reversed).should =~ [
          "Bradley, Bob",
          "O'Brady, Bobby" # <= dmetaphone match
        ]
      end

      it "should search for a complete last name match given a single word followed by a comma" do
        Customer.search("robert,").collect(&:name_reversed).should =~ [
          "Robert, Brady",
          "Roberts, Donna" # <= dmetaphone match
        ]
      end

      it "should search for a complete first name match and a last name that begins with the second set of characters given a word followed by a space followed by at least one word character" do
        Customer.search("don bo").collect(&:name_reversed).should =~ [
          "Bobson, Don",
          "Bradley, Don" # <= dmetaphone match
        ]
      end
      
      it "should search for a complete last name match and a first name that begins with the second set of characters given a word followed by a comma followed by an optional space followed by at least one word character" do
        Customer.search("Bradley, b").collect(&:name_reversed).should =~ [
          "Bradley, Bob"
        ]
      end
      
      it "should search for a first name or a last name that begins with the term given at least one word character with no trailing whitespace" do
        Customer.search("bra").collect(&:name_reversed).should =~ [
          "Bradley Sr., Robert",
          "Bradley, Don",
          "Srocco, Bradley",
          "Bradley, Bob",
          "Robert, Brady"
        ]
      end

      it "should return no customers when passed a nil term" do
        Customer.search(nil).collect(&:name_reversed).should =~ []
      end

      it "should return all customers when passed a blank term" do
        Customer.search("").collect(&:name_reversed).should =~ [
          "Roberts, Donna",
          "Donnings, Jennifer",
          "Bradley Sr., Robert",
          "O'Brady, Bobby",
          "Srocco, Bradley",
          "Bobson, Don",
          "Bradley, Bob",
          "Carlson, Christopher",
          "Robert, Brady",
          "Bradley, Don"
        ]
      end
      
      it "should strip leading space before performing the search" do
        Customer.search(" bob ").collect(&:name_reversed).should =~ [
          "Bradley, Bob",
          "O'Brady, Bobby" # <= dmetaphone match
        ]
      end

      it "should strip non-word and non-space characters before performing the search" do
        Customer.search("Bradley Sr.").collect(&:name_reversed).should =~ [
          "Srocco, Bradley"
        ]
      end
    else
      pending "Testing the search functionality requires that the test environment is using a Postgresql database connection and that the test database has the dmetaphone libraries installed."
    end
  end
end
