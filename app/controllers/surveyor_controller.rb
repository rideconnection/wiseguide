#confusingly, this handles both surveys and response sets
#due to the weirdness inherent in surveyor
require 'survey_creator'

module SurveyorControllerCustomMethods
  def self.included(base)
    # base.send :before_filter, :require_user   # AuthLogic
    # base.send :before_filter, :login_required  # Restful Authentication
    # base.send :layout, 'surveyor_custom'
  end


  # Actions (for responsesets)
  def new
    super
    @kase = Kase.find(params[:kase_id])
    @surveys = @surveys.select {|survey| survey.inactive_at.nil?} if @surveys.present?
  end
  def create
    @kase = Kase.find(params[:kase_id])
    authorize! :manage, @kase
    super
    @response_set.update_attributes({:kase_id => @kase.id})
  end
  def show
    super
  end
  def edit
    super
  end
  def update
    @response_set = ResponseSet.find_by_access_code(params[:response_set_code])
    @kase = @response_set.kase
    authorize! :manage, @kase
    super
  end

  def surveyor_finish
    @kase.assessment_complete
    kase_path @kase
  end

  def delete_response_set
    @response_set = ResponseSet.find_by_access_code(params[:response_set_code])
    authorize! :manage, @response_set
    @kase = @response_set.kase
    @response_set.destroy
    redirect_to @kase
  end

  # Actions for surveys
  def new_survey
    
  end

  def create_survey
    authorize! :manage, Survey
    survey_obj = JSON.parse(params[:survey])
    ret = SurveyCreator.create_survey(survey_obj)
    if ret =~ /^Malformed question/
      flash[:alert] = ret
      return render :action=>:new_survey
    elsif ret =~ /^Malformed JSON/
      flash[:alert] = ret
      render :action => :new_survey
    else
      redirect_to(surveys_path, :notice => 'Survey was successfully created.')
    end
  end

  def index
    authorize! :read, Survey
    @surveys = Survey.all
  end

  def destroy
    @survey = Survey.find(params[:id])
    @survey.inactive_at = DateTime.current
    @survey.save!
    redirect_to surveys_path
  end

  def reactivate
    @survey = Survey.find(params[:survey_id])
    @survey.inactive_at = DateTime.current
    @survey.save!
    redirect_to surveys_path
  end
end

class SurveyorController < ApplicationController
  include Surveyor::SurveyorControllerMethods
  include SurveyorControllerCustomMethods
  
  layout "application"
end
