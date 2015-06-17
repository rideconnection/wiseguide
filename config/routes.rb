Wiseguide::Application.routes.draw do
  resources :ada_service_eligibility_statuses
  resources :agencies
  resources :contacts
  resources :counties
  resources :customer_impairments, except: [:index, :show]
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
      put :complete_disposition
    end
  end

  resources :assessment_requests do
    member do
      get :download_attachment
    end
  end

  resources :customers do
    collection do
      get :search
    end
    
    member do
      get :download_original_portrait
      get :download_small_portrait
    end
  end

  # These routes are for managing assessment surveys
  resources :surveys, only: [:index, :new, :create, :destroy] do
    post :reactivate, on: :member
  end

  resources :kases, path: "cases" do 
    get  :coaching, on: :collection, action: :index, kase: {type: 'CoachingKase'}
    get  :training, on: :collection, action: :index, kase: {type: 'TrainingKase'}
    get  :customer_service, on: :collection, action: :index, kase: {type: 'CustomerServiceKase'}
    post :add_route, on: :collection
    post :delete_route, on: :collection
    post :notify_manager, on: :member
  end

  # These routes are for responding to assessment surveys
  # TODO Technically they belong to a kase, but that routing isn't working in 
  # Rails 3.2. See https://github.com/rails/rails/pull/12699
  Surveyor::Engine.routes.prepend do
    match "/:survey_code/:response_set_code", to: "surveyor#destroy", via: :delete
  end
  mount Surveyor::Engine => "/kases/:kase_id/surveys", as: :surveyor

  devise_for :users, controllers: {sessions: "users"}
  devise_scope :user do
    delete :user,                 to: "users#delete"
    get    :edit_user,            to: "users#edit"
    get    :init,                 to: "users#show_init"
    get    :new_user,             to: "users#new_user"
    get    :show_change_password, to: "users#show_change_password"
    patch  :change_password,      to: "users#change_password"
    post   :create_user,          to: "users#create_user"
    post   :init,                 to: "users#init"
    post   :logout,               to: "users#sign_out"
    post   :update_user,          to: "users#update"
    put    :create_user,          to: "users#create_user"
    patch  :update_user_details,  to: "users#update_details"
  end

  get  :admin, to: "admin#index"
  get  "assessment_requests/(:id)/change_customer" => "assessment_requests#change_customer"
  get  "assessment_requests/(:id)/change_coaching_kase" => "assessment_requests#change_coaching_kase"
  post "assessment_requests/(:id)/select_customer" => "assessment_requests#select_customer"
  post "assessment_requests/(:id)/select_coaching_kase" => "assessment_requests#select_coaching_kase"
  get  :reports, to: "reports#index"
  get  "reports(/:action)", controller: :reports
  get  "resources/(:id)/toggle_active" => "resources#toggle_active"
  get  :search_date, to: "home#search_date"
  get  :search_name, to: "home#search_name"
  get  :test_exception_notification, to: "application#test_exception_notification"
  get  :users, to: "admin#users"

  root to: "home#index"
end
