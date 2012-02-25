Wiseguide::Application.routes.draw do
  resources :assessment_requests

  resources :resources

  resources :organizations

  resources :counties

  resources :trip_reasons

  resources :routes

  resources :referral_types

  resources :impairments

  resources :funding_sources

  resources :event_types

  resources :ethnicities

  resources :dispositions

  resources :customer_support_network_members
  
  resources :customer_impairments, :except => [:index, :show]

  resources :customers do
    collection do
      get  :search
    end
    
    member do
      get :download_original_portrait
      get :download_small_portrait
    end
  end

  resources :kases, :path => "cases" do 
    post "add_route", :on=>:collection
    post "delete_route", :on=>:collection
    get "coaching", :on=>:collection, :action => :index, :kase => {:type => 'CoachingKase'}
    get "training", :on=>:collection, :action => :index, :kase => {:type => 'TrainingKase'}
  end

  resources :contacts

  resources :events

  #these are called "assessments" in user-visible text
  resources :surveys, :controller=>'Surveyor' do
    delete "/:survey_code/:response_set_code/delete", :to => "surveyor#delete_response_set", :as=>:delete, :on=>:collection
    get "new_survey", :on=>:collection
    put "new_survey", :on=>:collection, :to=>"surveyor#create_survey", :as=>:new_survey
    post "reactivate_survey", :to=>"surveyor#reactivate", :as=>:reactivate
  end

  resources :outcomes

  devise_for :users, :controllers=>{:sessions=>"users"} do
    get "new_user" => "users#new_user"
    get "edit_user" => "users#edit"
    post "create_user" => "users#create_user"
    put "create_user" => "users#create_user"
    get "init" => "users#show_init"
    post "logout" => "users#sign_out"
    post "init" => "users#init"
    put "update_user_details" => "users#update_details"
    post "update_user" => "users#update"
    delete "user" => "users#delete"
    get "show_change_password" => "users#show_change_password"
    match "change_password"  => "users#change_password"

  end

  match 'users', :controller=>:admin, :action=>:users
  match 'admin', :controller=>:admin, :action=>:index
  match 'reports', :controller=>:reports, :action=>:index

  match 'reports(/:action)', :controller=>:reports

  match "test_exception_notification" => "application#test_exception_notification"
  match "resources/(:id)/toggle_active",
        :controller=>:resources, :action=>:toggle_active

  match "assessment_requests/(:id)/change_customer",
        :controller=>:assessment_requests, :action=>:change_customer
  match "assessment_requests/(:id)/select_customer",
        :controller=>:assessment_requests, :action=>:select_customer
  match "assessment_requests/(:id)/create_case",
        :controller=>:assessment_requests, :action=>:create_case

  match 'search_name', :controller=>:home, :action=>:search_name
  match 'search_date', :controller=>:home, :action=>:search_date

  root :to => "home#index"
end
