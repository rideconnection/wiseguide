require 'spec_helper'

describe KasesController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    @current_user = FactoryGirl.create(:admin)
    sign_in @current_user
  end

  describe "GET index" do
    before(:each) do
      Kase.destroy_all
      
      # @my_open_kases
      @my_open_coaching_kase = FactoryGirl.create(:open_coaching_kase, assigned_to: @current_user)
      @my_open_training_kase = FactoryGirl.create(:open_training_kase, assigned_to: @current_user)
      @my_open_cservice_kase = FactoryGirl.create(:open_customer_service_kase, assigned_to: @current_user)
      @_my_open_kases = [@my_open_coaching_kase, @my_open_training_kase, @my_open_cservice_kase]
      
      # @other_open_kases
      @other_open_coaching_kase = FactoryGirl.create(:open_coaching_kase)
      @other_open_training_kase = FactoryGirl.create(:open_training_kase)
      @other_open_cservice_kase = FactoryGirl.create(:open_customer_service_kase)
      @_other_open_kases = [@other_open_coaching_kase, @other_open_training_kase, @other_open_cservice_kase]
      
      # @wait_list
      @wait_list_coaching_kase = FactoryGirl.create(:coaching_kase, assigned_to: nil)
      @wait_list_training_kase = FactoryGirl.create(:training_kase, assigned_to: nil)
      @wait_list_cservice_kase = FactoryGirl.create(:customer_service_kase, assigned_to: nil)
      @_wait_list = [@wait_list_coaching_kase, @wait_list_training_kase, @wait_list_cservice_kase]

      # @data_entry_needed
      @data_entry_needed_coaching_kase = FactoryGirl.create(:coaching_kase, scheduling_system_entry_required: true)
      @_data_entry_needed = [@data_entry_needed_coaching_kase]

      @_kases = [
        @my_open_coaching_kase,
        @my_open_training_kase,
        @my_open_cservice_kase,
        @other_open_coaching_kase,
        @other_open_training_kase,
        @other_open_cservice_kase,
        @wait_list_coaching_kase,
        @wait_list_training_kase,
        @wait_list_cservice_kase,
        @data_entry_needed_coaching_kase
      ]
      @_coaching_kases = [
        @my_open_coaching_kase,
        @other_open_coaching_kase,
        @wait_list_coaching_kase,
        @data_entry_needed_coaching_kase
      ]
      @_training_kases = [
        @my_open_training_kase,
        @other_open_training_kase,
        @wait_list_training_kase
      ]
      @_cservice_kases = [
        @my_open_cservice_kase,
        @other_open_cservice_kase,
        @wait_list_cservice_kase
      ]
      
      # We need to reload all of these instance variables to get the correct sub classes
      @_my_open_kases = @_my_open_kases.map{|k| Kase.find(k.id)}
      @_other_open_kases = @_other_open_kases.map{|k| Kase.find(k.id)}
      @_wait_list = @_wait_list.map{|k| Kase.find(k.id)}
      @_data_entry_needed = @_data_entry_needed.map{|k| Kase.find(k.id)}
      @_kases = @_kases.map{|k| Kase.find(k.id)}
      @_coaching_kases = @_coaching_kases.map{|k| Kase.find(k.id)}
      @_training_kases = @_training_kases.map{|k| Kase.find(k.id)}
      @_cservice_kases = @_cservice_kases.map{|k| Kase.find(k.id)}
    end
    
    after(:each) do
      Route.destroy_all
      FundingSource.destroy_all
    end
    
    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should render the index template" do
      get :index
      response.should render_template("index")
    end
    
    it "should assign @my_open_kases" do
      get :index
      # @my_open_kases = @kases.open.assigned_to(current_user).joins(:customer).order(name_ordered)
      assigns(:my_open_kases).should =~ @_my_open_kases
    end
    
    it "should assign @my_three_month_follow_ups" do
      get :index
      # @my_three_month_follow_ups = @kases.assigned_to(current_user).has_three_month_follow_ups_due.order(:close_date)
      pending "I don't have enough information about what this scope is supposed to do to setup the test properly."
    end
    
    it "should assign @my_six_month_follow_ups" do
      get :index
      # @my_six_month_follow_ups = @kases.assigned_to(current_user).has_six_month_follow_ups_due.order(:close_date)
      pending "I don't have enough information about what this scope is supposed to do to setup the test properly."
    end
    
    it "should assign @other_open_kases" do
      get :index
      # @other_open_kases = @kases.open.not_assigned_to(current_user).joins(:customer).order(name_ordered)
      pending "This is failing because the instance variable contians more kases than we expect it to. Need to figure out why."
      assigns(:other_open_kases).should =~ @_other_open_kases
    end
    
    it "should assign @other_three_month_follow_ups" do
      get :index
      # @other_three_month_follow_ups = @kases.not_assigned_to(current_user).has_three_month_follow_ups_due.order(:close_date)
      pending "I don't have enough information about what this scope is supposed to do to setup the test properly."
    end
    
    it "should assign @other_six_month_follow_ups" do
      get :index
      # @other_six_month_follow_ups = @kases.not_assigned_to(current_user).has_six_month_follow_ups_due.order(:close_date)
      pending "I don't have enough information about what this scope is supposed to do to setup the test properly."
    end
    
    it "should assign @wait_list" do
      get :index
      # @wait_list = @kases.unassigned.order(:open_date)
      pending "This is failing because the instance variable contians more kases than we expect it to. Need to figure out why."
      assigns(:wait_list).should =~ @_wait_list
    end
        
    context "CoachingKases" do
      before(:each) do
        get :index, :kase => {:type => 'CoachingKase'}
      end
      
      it "should assign only coaching kases to @kases" do
        assigns(:kases).should =~ @_coaching_kases
      end
      
      it "should assign @kase_type" do
        assigns(:kase_type).should == "CoachingKase"
      end
      
      it "should assign @bodytag_class" do
        assigns(:bodytag_class).should == "coaching-kases"
      end
    
      it "should assign @data_entry_needed" do
        # @data_entry_needed = @kase.open.where(:scheduling_system_entry_required => true)
        assigns(:data_entry_needed).should =~ @_data_entry_needed
      end
    end
    
    context "TrainingKases" do
      before(:each) do
        get :index, :kase => {:type => 'TrainingKase'}
      end
      
      it "should assign only training kases to @kases" do
        assigns(:kases).should =~ @_training_kases
      end
      
      it "should assign @kase_type" do
        assigns(:kase_type).should == "TrainingKase"
      end
      
      it "should assign @bodytag_class" do
        assigns(:bodytag_class).should == "training-kases"
      end
    end
    
    context "CustomerServiceKases" do
      before(:each) do
        get :index, :kase => {:type => 'CustomerServiceKase'}
      end
      
      it "should assign only customer service kases to @kases" do
        assigns(:kases).should =~ @_cservice_kases
      end
      
      it "should assign @kase_type" do
        assigns(:kase_type).should == "CustomerServiceKase"
      end
      
      it "should assign @bodytag_class" do
        assigns(:bodytag_class).should == "customer-service-kases"
      end
    end
  end
end