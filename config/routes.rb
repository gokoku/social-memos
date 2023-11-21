Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'

  root "home#index"
  get '/help', to: "home#help"

  resources :users
  get  '/signup', to: "users#new"
  post '/signup', to: "users#create"

  get '/login',      to: "sessions#new"
  post '/login',     to: "sessions#create"
  delete '/logout',  to: "sessions#destroy"

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
end
