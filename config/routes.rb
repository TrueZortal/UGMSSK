# frozen_string_literal: true

Rails.application.routes.draw do
  root 'mains#index'
  get '/game/:id', to: 'games#show'
  get '/start/:id', to: 'games#start'
  get '/reset/:id', to: 'games#reset'
  get '/login', to: 'logins#login'
  post '/login', to: 'logins#create'
  post '/logout', to: 'sessions#destroy'
  resources :board_fields
  resources :summoned_minions do
    post :update_attack, on: :member
    post :update_drag, on: :member
    get :grab, on: :member
  end
  resources :pvp_players do
    get :pass, on: :member
    get :concede, on: :member
    get :leave, on: :member
  end
  resources :board_states
  resources :games
end
