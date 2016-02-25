require 'rails_helper'

RSpec.describe SurveysController, type: :controller do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in FactoryGirl.create(:admin)
  end

  describe "GET #index" do
    before do
      @active_survey = FactoryGirl.create :survey
      @inactive_survey = FactoryGirl.create :survey, inactive_at: Date.today
    end
    
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "should assign @active_surveys" do
      get :index
      expect(assigns :active_surveys).to include(@active_survey)
      expect(assigns :active_surveys).not_to include(@inactive_survey)
    end

    it "should assign @inactive_surveys" do
      get :index
      expect(assigns :inactive_surveys).to include(@inactive_survey)
      expect(assigns :inactive_surveys).not_to include(@active_survey)
    end
  end

  describe "POST #create" do
    before do
      @params = {survey: {
        title: "Intake",
        sections: [
          {
            title: "Section 1",
            questions: [
                {
                type: "group",
                text: "Questions about the trainer",
                display_type: "default",
                questions: [
                  { title: "What is your favorite color?",
                    pick: "one",
                    answers: [
                      { text: "octarine", response_class: "answer"},
                      { text: "fuligin", response_class: "answer"},
                      { text: "bleen", response_class: "answer"}
                    ]
                  }
                ]
              },
              {
                type: "group",
                text: "Questions about modes",
                display_type: "repeater", 
                questions: [
                  { title: "What kind of mode does the client like?",
                    pick: "one", 
                    answers: [
                      { text: "bus", response_class: "answer"},
                      { text: "max", response_class: "answer"},
                      { text: "streetcar", response_class: "answer"},
                      { text: "aerial tram", response_class: "answer"},
                      { text: "teleportation", response_class: "answer"}
                    ]
                  },
                  { title: "How much does the client like this mode",
                    pick: "none",
                    answers: [ 
                      { text: "answer", response_class: "text"}
                    ]
                  }
                ]
              },
              { title: "Give me a number",
                pick: "none",
                answers: [ 
                  { text: "answer", response_class: "float"}
                ]
              },
              { 
                title: "Give me as many names as you like",
                pick: "none",
                answers: [ 
                  { text: "answer", response_class: "text"}
                ]
              }          
            ]
          }
        ]
      }.to_json}
    end
    
    it "creates a new survey" do
      expect {
        post :create, @params
      }.to change(Survey, :count).by(1)
    end
    
    it "redirects to the surveys list" do
      post :create, @params
      expect(response).to redirect_to(surveys_path)
    end
  end

  describe "DELETE #destroy" do
    before do
      @survey = FactoryGirl.create :survey
    end

    it "changes the inactive date for the survey" do
      expect {
        delete :destroy, {id: @survey.id}
      }.to change { @survey.reload.inactive_at }.from(nil)
    end
    
    it "doesn't destroy the survey" do
      expect {
        delete :destroy, {id: @survey.id}
      }.to change(Survey, :count).by(0)
    end

    it "redirects to the surveys list" do
      delete :destroy, {id: @survey.id}
      expect(response).to redirect_to(surveys_path)
    end
  end

  describe "POST #reactivate" do
    before do
      @survey = FactoryGirl.create :survey, inactive_at: Date.today
    end

    it "changes the inactive date for the survey" do
      expect {
        post :reactivate, {id: @survey.id}
      }.to change { @survey.reload.inactive_at }.to(nil)
    end
    
    it "redirects to the surveys list" do
      post :reactivate, {id: @survey.id}
      expect(response).to redirect_to(surveys_path)
    end
  end
end
