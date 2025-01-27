Rails.application.routes.draw do
  get 'categories/index'
  get 'categories/edit'
  resources :categories, except: [:new, :show]
  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show]

  devise_for :users

  resources :users, only:[:index, :show, :edit, :update] do
    member do
      get :follows, :followers
    end
    resource :relationships, only: [:create, :destroy]
  end

  resources :posts do
    resources :comments, only:[:create, :destroy]
    resource :favorites, only:[:create, :destroy]
    collection do
      get 'confirm'
    end
    collection do
      get 'search_by_category'
    end
  
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
  
  # Defines the root path route ("/")
  # root "posts#index"
  root 'homes#top'
end

