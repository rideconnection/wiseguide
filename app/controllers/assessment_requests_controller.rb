class AssessmentRequestsController < ApplicationController
  load_and_authorize_resource :except => [:change_customer, :select_customer]

  # GET /assessment_requests
  # GET /assessment_requests.xml
  def index    
    params[:user_type_filter]      = params[:user_type_filter]      || session[:assessment_requests_index_user_type_filter]      || "all"
    params[:current_status_filter] = params[:current_status_filter] || session[:assessment_requests_index_current_status_filter] || "all"
    params[:assignee_filter]       = params[:assignee_filter]       || session[:assessment_requests_index_assignee_filter]       || "all"

    query = @assessment_requests.scoped
        
    case params[:user_type_filter].to_sym
    when :mine
      query = query.submitted_by(current_user)
    when :my_organization
      query = query.belonging_to(current_user.organization)
    when :outside_users
      query = query.belonging_to(Organization.outside)
    end
        
    case params[:current_status_filter].to_sym
    when :pending
      query = query.pending
    when :not_completed
      query = query.not_completed
    when :completed
      query = query.completed
    end
        
    case params[:assignee_filter].to_sym
    when :me
      query = query.assigned_to(current_user)
    end
        
    @assessment_requests = query.order("created_at ASC").paginate(
      :page => params[:page])
    
    session[:assessment_requests_index_user_type_filter]      = params[:user_type_filter]
    session[:assessment_requests_index_current_status_filter] = params[:current_status_filter]
    session[:assessment_requests_index_assignee_filter]       = params[:assignee_filter]
    
    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
      format.xml  { render :xml => @assessment_requests }
    end
  end

  # GET /assessment_requests/1
  # GET /assessment_requests/1.xml
  def show
    prep_edit

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @assessment_request }
    end
  end

  # GET /assessment_requests/1/edit
  def edit
    prep_edit

    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @assessment_request }
    end
  end

  # GET /assessment_requests/new
  # GET /assessment_requests/new.xml
  def new
    prep_edit

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @assessment_request }
    end
  end

  # GET /assessment_requests/1/change_customer
  def change_customer
    @assessment_request = AssessmentRequest.find(params[:id])
    authorize! :update, @assessment_request
    @similar_customers = Customer.search(@assessment_request.display_name).order('last_name, first_name')
  end

  # GET /assessment_requests/1/change_coaching_kase
  def change_coaching_kase
    @assessment_request = AssessmentRequest.find(params[:id])
    authorize! :update, @assessment_request
    @potential_kases = @assessment_request.customer.kases.where(:type => 'CoachingKase').order(:open_date)
  end

  # POST /assessment_requests/1/select_customer
  def select_customer
    @assessment_request = AssessmentRequest.find(params[:assessment_request])
    authorize! :update, @assessment_request
    if params[:customer_id] == "0" then
      customer = {
        :first_name => @assessment_request.customer_first_name,
        :last_name => @assessment_request.customer_last_name,
        :middle_initial => @assessment_request.customer_middle_initial,
        :phone_number_1 => @assessment_request.customer_phone,
        :birth_date => @assessment_request.customer_birth_date,
        :notes => @assessment_request.notes,
      }
      redirect_to :controller=>:customers, :action=>:new, :customer=>customer,
                  :assessment_request=>@assessment_request
    else
      customer = Customer.find(params[:customer_id])
      @assessment_request.customer = customer
      @assessment_request.save!
      redirect_to @assessment_request
    end
  end

  # POST /assessment_requests/1/select_coaching_kase
  def select_coaching_kase
    @assessment_request = AssessmentRequest.find(params[:assessment_request])
    authorize! :update, @assessment_request
    if params[:kase_id] == "0" then
      kase = {
        :type => :CoachingKase,
        :assessment_request_id => @assessment_request.id,
        :case_manager_id => @assessment_request.submitter.id,
      }
      redirect_to :controller => :kases, :action => :new, :kase => kase,
                  :customer_id => @assessment_request.customer_id
    else
      kase = Kase.find(params[:kase_id])
      @assessment_request.kase = kase
      @assessment_request.save!
      redirect_to @assessment_request
    end
  end

  # POST /assessment_requests
  # POST /assessment_requests.xml
  def create
    prep_edit
    
    @assessment_request.submitter = current_user

    respond_to do |format|
      if @assessment_request.save
        format.html do
          redirect_to current_user.is_outside_user? ? root_path : assessment_requests_path,
                      :notice => 'Assessment request was successfully created.'
        end
        format.xml do
           render :xml => @assessment_request, :status => :created,
                  :location => @assessment_request
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @assessment_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assessment_requests/1
  # PUT /assessment_requests/1.xml
  def update
    prep_edit
    
    respond_to do |format|
      if @assessment_request.update_attributes(assessment_request_params)
        format.html do
          redirect_to current_user.is_outside_user? ? root_path : assessment_requests_path,
                      :notice => 'Assessment request was successfully updated.'
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "show" }
        format.xml  { render :xml => @assessment_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assessment_requests/1
  # DELETE /assessment_requests/1.xml
  def destroy
    @assessment_request.destroy

    respond_to do |format|
      format.html { redirect_to(assessment_requests_url) }
      format.xml  { head :ok }
    end
  end

  # GET /assessment_requests/1/download_attachment
  def download_attachment
    if @assessment_request.attachment.exists?
      send_file @assessment_request.attachment.path,
                :type => @assessment_request.attachment_content_type,
                :disposition => 'inline'
    else
      raise ActionController::RoutingError.new('No attachment found')
    end
  end

  private

  def prep_edit
    @assignees = [User.new(:first_name=>'Unassigned')] + User.inside_or_selected(@assessment_request.assignee_id).accessible_by(current_ability)
  end
  
  def assessment_request_params
    params.require(:assessment_request).permit(
      :assignee_id,
      :attachment,
      :customer_birth_date,
      :customer_first_name,
      :customer_id,
      :customer_last_name,
      :customer_middle_initial,
      :customer_phone,
      :notes,
      :reason_not_completed,
    )
  end
end
