require 'sidekiq/web'

Rails.application.routes.draw do 
   
  devise_for :users
   
  authenticated :user do 
  	resources :searches
  	mount Sidekiq::Web => '/sidekiq'
  end
  
  root to: 'static_pages#index'
   
  # DO NOT PUT ANY ROUTE BELOW THIS ROUTE
  match '*path' => redirect('/'), via: :get
  # ANY ROUTE BELOW HERE WILL NEVER BE REACHED
end
