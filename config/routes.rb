Rails.application.routes.draw do
  # Routes for main resources
  resources :stores
  resources :employees
  resources :assignments
  resources :sessions
  resources :shifts
  resources :flavors
  resources :jobs
  resources :shift_jobs
  resources :store_flavors
  resources :users

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy', :as => :logout
  get "start_shift" => 'shifts#start_shift', :as => :start_shift
  get "end_shift" => 'shifts#end_shift', :as => :end_shift
  
  # Set the root url
  root :to => 'home#splash'  
  
end
