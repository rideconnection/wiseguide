class CustomersController < ApplicationController
  load_and_authorize_resource

  def index
    @customers = Customer.paginate :page => params[:page], :order => [:last_name, :first_name]
  end

  def show
    prep_edit
  end
  
  def download_small_portrait
    send_file(@customer.portrait.path(:small), :type => @customer.portrait_content_type, :disposition => 'inline') if @customer.portrait.path(:small)
  end

  def download_original_portrait
    send_file(@customer.portrait.path(:original), :type => @customer.portrait_content_type) if @customer.portrait.path(:small)
  end

  def new
    if !params[:assessment_request].nil? then
      @assessment_request = params[:assessment_request]
    end
    prep_edit
  end

  def create
    @customer = Customer.new(params[:customer])
    if !params[:assessment_request].nil? then
      @assessment_request = params[:assessment_request]
    end
    if @customer.save
      notice = 'Customer was successfully created.'
      if !@assessment_request.nil? then
        request = AssessmentRequest.find(@assessment_request)
        request.customer = @customer
        request.save!
        redirect_to :controller=>:assessment_requests, :action=>:show,
                    :id=>params[:assessment_request], :notice=>notice
      else
        redirect_to(@customer, :notice => notice) 
      end
    else
      prep_edit
      render :action => "new"
    end
  end

  def update
    if @customer.update_attributes(params[:customer])
      redirect_to(@customer, :notice => 'Customer was successfully updated.') 
    else
      prep_edit
      render :action => "show"
    end
  end

  def destroy
    @customer.destroy
    redirect_to(customers_url, :notice => 'Customer was successfully deleted.')
  end
  
  def search
    term = params[:name].downcase.strip
    
    @customers = Customer.search(term).paginate( :page => params[:page], :order => [:last_name, :first_name])
    render :action => :index
  end

  private
  
  def prep_edit
    @ethnicities = Ethnicity.all
    @genders = ALL_GENDERS
    @counties = (County.all.collect {|c| c.name} << @customer.county).compact.uniq.sort
    @ada_service_eligibility_statuses = AdaServiceEligibilityStatus.order(:name).all
  end
end
