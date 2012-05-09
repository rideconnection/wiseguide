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
        FactoryGirl.create(:customer, :first_name => "Donna",       :last_name => "Jennings")
        FactoryGirl.create(:customer, :first_name => "Jennifer",    :last_name => "Donnings")
        FactoryGirl.create(:customer, :first_name => "Robert",      :last_name => "Bradey Sr.")
        FactoryGirl.create(:customer, :first_name => "Bobby",       :last_name => "O'Brady")
        FactoryGirl.create(:customer, :first_name => "Bradley",     :last_name => "Christchurch")
        FactoryGirl.create(:customer, :first_name => "Don",         :last_name => "Bobson")
        FactoryGirl.create(:customer, :first_name => "Bob",         :last_name => "Bradey")
        FactoryGirl.create(:customer, :first_name => "Christopher", :last_name => "Carlson")
        FactoryGirl.create(:customer, :first_name => "Brady",       :last_name => "Robert")
        FactoryGirl.create(:customer, :first_name => "Barb",        :last_name => "Bradey")
      end
    
      after(:all) do
        Customer.destroy_all
      end
    
      # FYI - The results for these searches may not seem predictable when run
      # against a Postgres data source because we will be relying on a 
      # dmetaphone phonetic algorithm to do "fuzzy matching", similar to a 
      # soundex search. When in doubt, run the search manually and copy the 
      # results in to the expected results...

      it "should allow me to search using a single letter" do
        Customer.search("a").collect(&:name_reversed).should =~ [
          "Jennings, Donna", 
          "Donnings, Jennifer", 
          "O'Brady, Bobby"
        ]
      end

      it "should allow me to search using a partial name" do
        Customer.search("bra").collect(&:name_reversed).should =~ [
          "Bradey Sr., Robert",
          "Bradey, Barb",
          "Christchurch, Bradley",
          "Bradey, Bob",
          "Robert, Brady"
        ]
      end

      it "should allow me to search using a complete name" do
        Customer.search("robert").collect(&:name_reversed).should =~ [
          "Bradey Sr., Robert", 
          "Robert, Brady"
        ]
      end

      it "should allow me to search using a first name and the first letter of a last name" do
        Customer.search("robert b").collect(&:name_reversed).should =~ [
          "Bradey Sr., Robert"
        ]
      end

      it "should allow me to search using a first name and the first few letters of a last name" do
        Customer.search("DONNA JEN").collect(&:name_reversed).should =~ [
          "Jennings, Donna"
        ]
      end

      it "should allow me to search using a last name, a comma, and some of a first name" do
        Customer.search("bradey, b").collect(&:name_reversed).should =~ [
          "Bradey, Barb",
          "Bradey, Bob"
        ]
      end

      it "should allow me to search using a last name, a comma, and all of a first name" do
        pp Customer.search("bradey, barb").collect(&:name_reversed)
        Customer.search("bradey, barb").collect(&:name_reversed).should =~ [
          "Bradey, Barb"
        ]
      end

      it "should allow me to search for names that include non-alpha characters" do
        Customer.search("Bradey Sr.").collect(&:name_reversed).should =~ [
          "Bradey Sr., Robert"
        ]
      end

      it "should return all customers when passed a nil term" do
        Customer.search(nil).collect(&:name_reversed).should =~ [
          "Jennings, Donna",
          "Donnings, Jennifer",
          "Bradey Sr., Robert",
          "O'Brady, Bobby",
          "Christchurch, Bradley",
          "Bobson, Don",
          "Bradey, Bob",
          "Carlson, Christopher",
          "Robert, Brady",
          "Bradey, Barb"
        ]
      end

      it "should return all customers when passed a blank term" do
        Customer.search("").collect(&:name_reversed).should =~ [
          "Jennings, Donna",
          "Donnings, Jennifer",
          "Bradey Sr., Robert",
          "O'Brady, Bobby",
          "Christchurch, Bradley",
          "Bobson, Don",
          "Bradey, Bob",
          "Carlson, Christopher",
          "Robert, Brady",
          "Bradey, Barb"
        ]
      end

      it "should strip whitespace from the search term" do
        Customer.search("  DONNA JEN   ").collect(&:name_reversed).should =~ [
          "Jennings, Donna"
        ]
      end
    else
      pending "Testing the search functionality requires that the test environment is using a Postgresql database connection and that the test database has the dmetaphone libraries installed."
    end
  end
end
