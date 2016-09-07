class CustomersController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource only: [:download_small_portrait, :download_original_portrait]

  def index
    @customers = @customers.order(:last_name, :first_name).paginate(page: params[:page])
  end

  def show
    prep_edit
  end
  
  def download_small_portrait
    authorize! :read, @customer
    send_file(@customer.portrait.path(:small), type: @customer.portrait_content_type, disposition: 'inline') if @customer.portrait.exists?(:small)
  end

  def download_original_portrait
    authorize! :read, @customer
    send_file(@customer.portrait.path(:original), type: @customer.portrait_content_type) if @customer.portrait.exists?(:small)
  end

  def new
    if !params[:assessment_request].nil? then
      @assessment_request = params[:assessment_request]
    end
    prep_edit
  end

  def create
    if !params[:assessment_request].nil? then
      @assessment_request = params[:assessment_request]
    end

    if @customer.save
      notice = 'Customer was successfully created.'
      if !@assessment_request.nil? then
        request = AssessmentRequest.find(@assessment_request)
        request.customer = @customer
        request.save!
        redirect_to controller: :assessment_requests, action: :show,
                    id: params[:assessment_request], notice: notice
      else
        redirect_to(@customer, notice: notice) 
      end
    else
      prep_edit
      render action: "new"
    end
  end

  def update
    if @customer.update_attributes(customer_params)
      redirect_to(@customer, notice: 'Customer was successfully updated.') 
    else
      prep_edit
      render action: "show"
    end
  end

  def destroy
    begin
      @customer.destroy
    rescue ActiveRecord::DeleteRestrictionError
      redirect_to(customers_url, alert: 'Customer could not be deleted because its related records must be deleted first.')
    else
      redirect_to(customers_url, notice: 'Customer was successfully deleted.')
    end
  end
  
  def search
    term = params[:name].downcase.strip
    
    @customers = Customer.search(term).order(:last_name, :first_name).paginate(page: params[:page])

    respond_to do |format|
      format.html { render action: :index }
      format.json { render json: @customers }
    end
  end

  private
  
  def prep_edit
    @ethnicities = Ethnicity.all
    @genders = ALL_GENDERS
    @counties = (County.all.collect {|c| c.name} << @customer.county).compact.uniq.sort
    @ada_service_eligibility_statuses = AdaServiceEligibilityStatus.order(:name)
  end
  
  def customer_params
    params.require(:customer).permit(
      :ada_service_eligibility_status_id,
      :address,
      :birth_date,
      :city,
      :county,
      :email,
      :ethnicity_id,
      :first_name,
      :gender,
      :honored_citizen_cardholder,
      :last_name,
      :middle_initial,
      :identifier,
      :notes,
      :phone_number_1,
      :phone_number_1_allow_voicemail,
      :phone_number_2,
      :phone_number_2_allow_voicemail,
      :phone_number_3,
      :phone_number_3_allow_voicemail,
      :phone_number_4,
      :phone_number_4_allow_voicemail,
      :portrait,
      :primary_language,
      :spouse_of_veteran_status,
      :state,
      :veteran_status,
      :zip,
    )
  end
end
