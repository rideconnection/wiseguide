# TODO Verify Strong Parameters after upgrading Surveyor to v1.5

require 'survey_creator'

class SurveysController < ApplicationController
  load_and_authorize_resource :except => :create
  
  def index
    @active_surveys = @surveys.active.order(:title).includes(:response_sets)
    @inactive_surveys = @surveys.inactive.order(:title).includes(:response_sets)
  end
  
  def new
  end

  def create
    authorize! :manage, Survey
    begin
      survey_obj = JSON.parse(params[:survey])
      ret = SurveyCreator.create_survey(survey_obj)
    rescue => e
    end
        
    if e.present? || ret =~ /^Malformed/
      flash[:alert] = e.try(:message) || ret
      render :action => :new
    else
      redirect_to surveys_path, :notice => 'Survey was successfully created.'
    end
  end  
  
  def destroy
    @survey.inactive_at = DateTime.current
    @survey.save!
    redirect_to surveys_path, :notice => 'Survey was inactivated.'
  end

  def reactivate
    authorize! :manage, Survey
    @survey.inactive_at = nil
    @survey.save!
    redirect_to surveys_path, :notice => 'Survey was reactivated.'
  end
end