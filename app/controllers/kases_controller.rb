class KasesController < ApplicationController
  load_and_authorize_resource :except => [:new, :create]
  authorize_resource :only => [:new, :create]
  before_filter :cleanup_household_stat_params, :only => [:update, :create]

  def index
    name_ordered = 'customers.last_name, customers.first_name'
        
    if params[:kase].try(:[], :type).present?
      @kase_type = params[:kase][:type]
      @kases = @kases.where(:type => @kase_type)
      @bodytag_class = @kase_type.pluralize.underscore.gsub(/_/, '-')
    end
    
    @my_open_kases = @kases.open.assigned_to(current_user).joins(:customer).order(name_ordered)
    @my_three_month_follow_ups = @kases.assigned_to(current_user).has_three_month_follow_ups_due.order(:close_date)
    @my_six_month_follow_ups = @kases.assigned_to(current_user).has_six_month_follow_ups_due.order(:close_date)
    @other_open_kases = @kases.open.not_assigned_to(current_user).joins(:customer).order(name_ordered)
    @other_three_month_follow_ups = @kases.not_assigned_to(current_user).has_three_month_follow_ups_due.order(:close_date)
    @other_six_month_follow_ups = @kases.not_assigned_to(current_user).has_six_month_follow_ups_due.order(:close_date)
    @wait_list = @kases.unassigned.order(:open_date)
    
    if @kase_type == "CoachingKase"
      @data_entry_needed = (@kases.scheduling_system_entry_required.all + TripAuthorization.where(:kase_id => @kases.collect(&:id), :disposition_date => nil).all).sort{|a,b| a.created_at <=> b.created_at }
    end
  end

  def show
    prep_edit
  end

  def new
    params[:kase] ||= {}
    in_progress = Disposition.find_by_name_and_type('In Progress', "#{params[:kase][:type]}Disposition")
    params[:kase].merge!({:customer_id => params[:customer_id], :disposition_id => in_progress.id})
    setup_sti_model
    @kase.county = Kase::VALID_COUNTIES.fetch(Customer.find(params[:customer_id]).county,nil)
    prep_edit
  end

  def create
    setup_sti_model
    
    if @kase.save
      @kase.reload
      notice = "#{@kase.class.humanized_name} was successfully created."
      if !@kase.assessment_request_id.nil?
        request = AssessmentRequest.find(@kase.assessment_request_id)
        request.kase = @kase
        request.save!
        redirect_to(request, :notice => notice)
      else
        redirect_to(@kase, :notice => notice)
      end
    else
      prep_edit
      render :action => "new"
    end
  end

  def update
    @kase.attributes = kase_params
    
    state_changed = false
    if @kase.scheduling_system_entry_required_changed?
      state_changed = true
    end
    
    saved = false
    ActiveRecord::Base.transaction do
      if @kase.save
        saved = true
        begin
          generate_contact_event!(
            (@kase.scheduling_system_entry_required == true) ? "Case marked for entry into trip scheduling system" : "Data entry into trip scheduling system complete"
          ) if state_changed
        rescue ActiveRecord::RecordInvalid => err
          saved = false
          @kase.errors[:base] << "An error prevented the object from being saved. Please try again. (#{err.to_s})"
          raise ActiveRecord::Rollback
        end
      end
    end
    
    if saved
      redirect_to(@kase, :notice => '%s was successfully updated.' % @kase.class.humanized_name)
    else
      prep_edit
      render :action => "show"
    end
  end

  def destroy
    @kase.destroy
    redirect_to(kases_url, :notice => "%s was successfully deleted." % @kase.class.humanized_name)
  end

  def add_route
    @kase = Kase.find(params[:kase_route][:kase_id])
    authorize! :edit, @kase
    @kase_route = KaseRoute.create(params[:kase_route])
    @route = @kase_route.route
    render :layout=>nil
  end

  def delete_route
    @kase_route = KaseRoute.where(:kase_id=>params[:kase_id], :route_id=>params[:route_id])[0]
    @kase_route.destroy
    render :json=>{:action=>:destroy, :kase_id=>@kase_route.kase_id, :route_id=>@kase_route.route_id}
  end
  
  def notify_manager
    authorize! :edit, @kase
    if !@kase.case_manager.blank?
      ActiveRecord::Base.transaction do
        begin
          AssessmentMailer.customer_assessed_email(@kase.case_manager, @kase).deliver
          @kase.case_manager_notification_date = Date.current
          @kase.save!
          redirect_to(@kase, :notice => 'The notification has been sent.') and return
        rescue => err
          flash[:alert] = "An error prevented the object from being saved. Please try again. (#{err.to_s})"
          raise ActiveRecord::Rollback
        end
      end
    else
      flash[:alert] = "The notification could not be sent because there is no case manager assigned."
    end

    prep_edit
    render :action => "show"
  end

private
  
  def prep_edit
    @agencies = Agency.accessible_by(current_ability)
    @case_managers = User.cmo_or_selected(@kase.case_manager_id).accessible_by(current_ability)
    @dispositions = Disposition.accessible_by(current_ability).where(:type => "#{@kase.class.original_model_name}Disposition")
    @funding_sources = FundingSource.accessible_by(current_ability)
    @kase_route = KaseRoute.new(:kase_id => @kase.id)
    @referral_types = ReferralType.accessible_by(current_ability).order(:name).for_kase(@kase)
    @routes = Route.accessible_by(current_ability)
    @users = [User.new(:first_name=>'Unassigned')] + User.inside_or_selected(@kase.user_id).accessible_by(current_ability)
  end

  # Attempt to instantiate the correct Kase subclass based on the type 
  # parameter sent from forms and querystrings
  def setup_sti_model(enable_logging = false)
    logger.debug "Attempting to detect implied Kase subclass" if enable_logging
    if params[:kase].try(:[], :type).present?
      # Type param found, let's see if it's a valid subclass
      type = params[:kase].delete(:type)
      logger.debug "Type param '#{type}' found. Looking for match in list of Kase.descendants:" if enable_logging
      begin
        logger.debug "Attempting to constantize '#{type}' to a model class" if enable_logging

        model = type.constantize
        logger.debug "Attempting to instantiate '#{type}' model class" if enable_logging

        @kase = model.new(kase_params)
        logger.debug @kase.inspect if enable_logging
      rescue => e
        # Type param found, but an error prevented us from creating the 
        # object. Fall through to create a generic Kase object
        logger.debug "Type param '#{type}' found, but an error prevented us from creating the object: #{e}" if enable_logging
      else
        # No errors encountered, return having instantiated the proper 
        # subclass
        logger.debug "No errors encountered, returning" if enable_logging
        return
      end
    else
      # No type param was found, fall through to create a generic Kase object
      logger.debug "Type param not found" if enable_logging
    end
    # If all else fails just instantiate a generic Kase object
    logger.debug "Could not instantiate a subclass. Creating generic Kase object instead" if enable_logging
    @kase = Kase.new(kase_params)
    logger.debug @kase.inspect if enable_logging
  end
  
  def cleanup_household_stat_params
    if params[:kase].try(:[], :household_income_alternate_response).present?
      params[:kase][:household_income] = nil
    else
      params[:kase][:household_income_alternate_response] == nil
    end
    
    if params[:kase].try(:[], :household_size_alternate_response).present?
      params[:kase][:household_size] = nil
    else
      params[:kase][:household_size_alternate_response] == nil
    end
    
    # Remove any commas
    params[:kase][:household_income].gsub!(",", "") unless params[:kase][:household_income].blank?
    params[:kase][:household_size].gsub!(",", "") unless params[:kase][:household_size].blank?
  end
  
  def generate_contact_event!(description, notes = nil)
    Contact.create!(
      contactable: @kase,
      user: current_user,
      method: "Case Action",
      date_time: DateTime.current,
      description: description,
      notes: notes
    )
  end
  
  def kase_params
    params.require(:kase).permit(
      :access_transit_partner_referred_to,
      :adult_ticket_count,
      :agency_id,
      :assessment_date,
      :assessment_language,
      :assessment_request_id,
      :case_manager_id,
      :case_manager_notification_date,
      :category,
      :close_date,
      :county,
      :customer_id,
      :disposition_id,
      :eligible_for_ticket_disbursement,
      :funding_source_id,
      :honored_ticket_count,
      :household_income,
      :household_income_alternate_response,
      :household_size,
      :household_size_alternate_response,
      :medicaid_eligible,
      :open_date,
      :referral_mechanism,
      :referral_mechanism_explanation,
      :referral_source,
      :referral_type_id,
      :scheduling_system_entry_required,
      :user_id,
    )
  end
end
