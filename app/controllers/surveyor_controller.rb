# TODO Verify Strong Parameters after upgrading Surveyor to v1.5

# Surveyor Controller allows a user to respond to surveys. It is semi-RESTful
# since it does not have a concrete representation model. The "resource" is a 
# survey attempt/session populating a response set.

module SurveyorControllerCustomMethods
  def self.included(base)
    # base.send :before_filter, :require_user   # AuthLogic
    # base.send :before_filter, :login_required  # Restful Authentication
    base.send :layout, 'application'
  end

  # Actions
  def new
    @kase = Kase.find(params[:kase_id])
    authorize! :manage, @kase
    @surveys_by_access_code = Survey.active.order("created_at DESC, survey_version DESC").group_by(&:access_code)
    # Skip `super` since we're overwriting @surveys_by_access_code
  end
  
  def create
    @kase = Kase.find(params[:kase_id])
    authorize! :manage, @kase
    super
    @response_set.update_attribute(:kase_id, @kase.id)
  end
  
  def show
    @kase = Kase.find(params[:kase_id])
    authorize! :manage, @kase
    super
  end
  
  def edit
    @kase = Kase.find(params[:kase_id])
    authorize! :manage, @kase
    super
  end
  
  def update
    @response_set = ResponseSet.find_by_access_code(params[:response_set_code])
    @kase = @response_set.kase
    authorize! :manage, @kase
    super
  end

  # Paths
  def surveyor_index
    # most of the above actions redirect to this method
    kase_path @kase
  end

  def surveyor_finish
    # the update action redirects to this method if given params[:finish]
    @kase.update_attribute(:assessment_date, Date.current)
    kase_path @kase
  end

  # Wiseguide custom route actions
  def destroy
    @response_set = ResponseSet.find_by_access_code(params[:response_set_code])
    authorize! :manage, @response_set
    @response_set.destroy
    redirect_to kase_path @response_set.kase
  end
end

class SurveyorController < ApplicationController
  include Surveyor::SurveyorControllerMethods
  include SurveyorControllerCustomMethods
end
