require 'sidekiq/web'

Rails.application.routes.draw do
  # resources :search_results
  # resources :litigations
  
  mount Sidekiq::Web => '/sidekiq'
  
  root to: 'static_pages#index'
  
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  authenticated :user do 
  	resources :searches
  end
  
  # DO NOT PUT ANY ROUTE BELOW THIS ROUTE
  match '*path' => redirect('/'), via: :get
  # ANY ROUTE BELOW HERE WILL NEVER BE REACHED
end
