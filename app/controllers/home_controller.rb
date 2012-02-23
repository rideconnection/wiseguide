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
end
