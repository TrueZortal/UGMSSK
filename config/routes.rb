# frozen_string_literal: true

Rails.application.routes.draw do
  root 'mains#index'
  get '/game/:id', to: 'games#show'
  get '/start/:id', to: 'games#start'
  get '/reset/:id', to: 'games#reset'
  get '/login', to: 'logins#login'
  post '/login', to: 'logins#create'
  post '/logout', to: 'sessions#destroy'
  get 'user_data', to: 'user_data#index'
  resources :board_fields do
  # TODO: This can likely be removed
    get :refresh_fields, on: :member
  end
  resources :summoned_minions do
    post :update_drag, on: :member
    post :update_attack, on: :member
    get :grab, on: :member
  end
  resources :pvp_players do
    get :pass, on: :member
    get :concede, on: :member
    get :leave, on: :member
  end
  resources :board_states
  resources :games do
    post :user, on: :member
  end
end
