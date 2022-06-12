Rails.application.routes.draw do
  resources :frequency_distributions
  resources :items
  get 'posts/index'
  get 'posts/create'
  get 'posts/new'
  get 'posts/update'
  get 'posts/edit'
  get 'posts/destroy'
  get 'posts/show'
  resources :posts
  
  root to: "main#index"
  get "dashboard1" => "dashboard#dashboard_1"
  get "dashboard2" => "dashboard#dashboard_2"
  get "inventory_report" => "inventoryreport#index"

  get "about_us" => "about#index"

  get "sign_up" => "registrations#new"
  post "sign_up" => "registrations#create"

  get "sign_in" => "sessions#new"
  post "sign_in" => "sessions#create"

  delete "sign_out" => "sessions#destroy"

  resources :items do
    collection do
      post :import
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
