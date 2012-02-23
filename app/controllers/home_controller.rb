class HomeController < ApplicationController

  def index
    if current_user.is_outside_user? then
      org_assessments = current_user.organization.assessment_requests
      @pending_assessments = org_assessments.where(:kase_id => nil)
      @recent_cases = []
      org_assessments.each do |request|
        @recent_cases << request.kase unless request.kase.nil?
      end
      render :outside_dashboard
    end
  end

  def search_name
    @query = params[:customer_name]
    customers = Customer.search(params[:customer_name])
    @search_results = Kase.where(:customer_id => customers)
  end

  def search_date
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    if @start_date.empty? or @end_date.empty? then
      flash.now[:notice] = "Please enter start and end dates."
      @search_results = []
    else
      @search_results = Kase.where("open_date between ? and ?",
                                   @start_date, @end_date)
    end
  end
end
