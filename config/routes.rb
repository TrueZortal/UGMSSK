# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root 'games#start'
  root 'mains#index'
  get '/game/:id', to: 'games#show'
  get '/start/:id', to: 'games#start'
  get '/reset/:id', to: 'games#reset'
  get '/login', to: 'logins#login'
  post '/login', to: 'logins#create'
  post '/logout', to: 'sessions#destroy'
  resources :summoned_minions do
    post :update_attack, on: :member
    post :update_drag, on: :member
    get :grab, on: :member # function for grabbing record via JS
  end
  resources :pvp_players do
    get :pass, on: :member
    get :concede, on: :member
    get :leave, on: :member
  end
  resources :board_states
  resources :games
end
