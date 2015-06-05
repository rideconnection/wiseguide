Wiseguide::Application.routes.draw do
  resources :ada_service_eligibility_statuses
  resources :agencies
  resources :contacts
  resources :counties
  resources :customer_impairments, :except => [:index, :show]
  resources :customer_support_network_members
  resources :dispositions
  resources :ethnicities
  resources :events
  resources :event_types
  resources :funding_sources
  resources :impairments
  resources :organizations
  resources :outcomes
  resources :referral_documents
  resources :referral_types
  resources :resources
  resources :routes
  resources :trip_reasons

  resources :trip_authorizations do
    member do
      put "complete_disposition"
    end
  end

  resources :assessment_requests do
    member do
      get 'download_attachment'
    end
  end

  resources :customers do
    collection do
      get  :search
    end
    
    member do
      get :download_original_portrait
      get :download_small_portrait
    end
  end

  # These routes are for managing assessment surveys
  resources :surveys, :only => [:index, :new, :create, :destroy] do
    post :reactivate, :on => :member
  end

  resources :kases, :path => "cases" do 
    get "coaching", :on=>:collection, :action => :index, :kase => {:type => 'CoachingKase'}
    get "training", :on=>:collection, :action => :index, :kase => {:type => 'TrainingKase'}
    get "customer_service", :on=>:collection, :action => :index, :kase => {:type => 'CustomerServiceKase'}
    post "add_route", :on=>:collection
    post "delete_route", :on=>:collection
    post "notify_manager", :on => :member
  end

  # These routes are for responding to assessment surveys
  # TODO Technically they belong to a kase, but that routing isn't working in 
  # Rails 3.2. See https://github.com/rails/rails/pull/12699
  Surveyor::Engine.routes.prepend do
    match "/:survey_code/:response_set_code", :to => "surveyor#destroy", :via => :delete
  end
  mount Surveyor::Engine => "/kases/:kase_id/surveys", :as => "surveyor"

  devise_for :users, :controllers=>{:sessions=>"users"}
  devise_scope :user do
    delete "user" => "users#delete"
    get "edit_user" => "users#edit"
    get "init" => "users#show_init"
    get "new_user" => "users#new_user"
    get "show_change_password" => "users#show_change_password"
    match "change_password"  => "users#change_password"
    post "create_user" => "users#create_user"
    post "init" => "users#init"
    post "logout" => "users#sign_out"
    post "update_user" => "users#update"
    put "create_user" => "users#create_user"
    put "update_user_details" => "users#update_details"
  end

  match "admin", :controller=>:admin, :action=>:index
  match "assessment_requests/(:id)/change_customer", :controller=>:assessment_requests, :action=>:change_customer
  match "assessment_requests/(:id)/change_coaching_kase", :controller=>:assessment_requests, :action=>:change_coaching_kase
  match "assessment_requests/(:id)/select_customer", :controller=>:assessment_requests, :action=>:select_customer
  match "assessment_requests/(:id)/select_coaching_kase", :controller=>:assessment_requests, :action=>:select_coaching_kase
  match "reports", :controller=>:reports, :action=>:index
  match "reports(/:action)", :controller=>:reports
  match "resources/(:id)/toggle_active", :controller=>:resources, :action=>:toggle_active
  match "search_date", :controller=>:home, :action=>:search_date
  match "search_name", :controller=>:home, :action=>:search_name
  match "test_exception_notification" => "application#test_exception_notification"
  match "users", :controller=>:admin, :action=>:users

  root :to => "home#index"
end
