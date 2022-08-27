# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'games#start'
  get '/reset', to: 'games#reset'
  resources :summoned_minions do
    post :update_attack, on: :member
    get :grab, on: :member # function for grabbing record via JS
  end
  resources :pvp_players do
    get :pass, on: :member
    get :concede, on: :member
  end
  resources :board_states
  resources :games
end
