# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'games#start'
  get '/reset', to: 'games#reset'
  get '/add_player', to: 'games#add_player'
  get '/remove_player', to: 'games#remove_player'
  resources :summoned_minions do
    post :update_attack, on: :member
  end
  resources :board_states
  resources :games
end
