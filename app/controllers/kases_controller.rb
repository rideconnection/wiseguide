class KasesController < ApplicationController
  load_and_authorize_resource

  def index
    name_ordered = 'customers.last_name, customers.first_name'
    
    @my_open_kases = @kases.open.assigned_to(current_user).joins(:customer).order(name_ordered)
    @my_three_month_follow_ups = @kases.assigned_to(current_user).has_three_month_follow_ups_due.order(:close_date)
    @my_six_month_follow_ups = @kases.assigned_to(current_user).has_six_month_follow_ups_due.order(:close_date)
    @other_open_kases = @kases.open.not_assigned_to(current_user).joins(:customer).order(name_ordered)
    @other_three_month_follow_ups = @kases.not_assigned_to(current_user).has_three_month_follow_ups_due.order(:close_date)
    @other_six_month_follow_ups = @kases.not_assigned_to(current_user).has_six_month_follow_ups_due.order(:close_date)
    @wait_list = @kases.unassigned.order(:open_date)
  end

  def show
    prep_edit
  end

  def new
    params[:kase] ||= {}
    in_progress = Disposition.find_by_name('In Progress')
    params[:kase].merge!({:customer_id => params[:customer_id], :disposition_id => in_progress.id})
    setup_sti_model
    @kase.county = Kase::VALID_COUNTIES.fetch(Customer.find(params[:customer_id]).county,nil)
    prep_edit
  end

  def create
    setup_sti_model
    
    if @kase.save
      @kase.reload
      redirect_to(@kase, :notice => '%s was successfully created.' % @kase.class.human_name.sub(/\bKase\b/, 'Case')) 
    else
      prep_edit
      render :action => "new"
    end
  end

  def update
    if @kase.update_attributes(params[:kase])
      redirect_to(@kase, :notice => '%s was successfully updated.' % @kase.class.human_name.sub(/\bKase\b/, 'Case')) 
    else
      prep_edit
      render :action => "show"
    end
  end

  def destroy
    @kase.destroy
    redirect_to(kases_url, :notice => "%s was successfully deleted." % @kase.class.human_name.sub(/\bKase\b/, 'Case'))
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

private
  
  def prep_edit
    @referral_types = ReferralType.accessible_by(current_ability)
    @users = [User.new(:email=>'Unassigned')] + User.inside_or_selected(@kase.user_id).accessible_by(current_ability)
    @case_managers = User.outside_or_selected(@kase.case_manager_id).accessible_by(current_ability)
    @dispositions = Disposition.accessible_by(current_ability)
    @funding_sources = FundingSource.accessible_by(current_ability)

    @kase_route = KaseRoute.new(:kase_id => @kase.id)
    @routes = Route.accessible_by(current_ability)
  end

  def setup_sti_model
    # Attempt to instantiate the correct Kase subclass based on the type 
    # parameter sent from forms and querystrings
    # logger.debug "Attempting to detect implied Kase subclass"
    if !params[:kase].blank? and !params[:kase][:type].blank?
      # Type param found, let's see if it's a valid subclass
      type = params[:kase].delete(:type)
      # logger.debug "Type param '#{type}' found. Looking for match in list of Kase.descendants:"
      begin
        # logger.debug "Attempting to constantize '#{type}' to a model class"
        model = type.constantize
        # logger.debug "Attempting to instantiate '#{type}' model class"
        @kase = model.new(params[:kase])
        # logger.debug @kase.inspect
      rescue => e
        # Type param found, but an error prevented us from creating the 
        # object. Fall through to create a generic Kase object
        # logger.debug "Type param '#{type}' found, but an error prevented us from creating the object: #{e}"
      else
        # No errors encountered, return having instantiated the proper 
        # subclass
        # logger.debug "No errors encountered, returning"
        return
      end
    else
      # No type param was found, fall through to create a generic Kase object
      # logger.debug "Type param not found"
    end
    # If all else fails just instantiate a generic Kase object
    # logger.debug "Could not instantiate a subclass. Creating generic Kase object instead"
    @kase = Kase.new(params[:kase])
    # logger.debug @kase.inspect
  end
end
