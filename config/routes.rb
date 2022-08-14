# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'games#start'
  get '/boardstates', to: 'boards_state#index'
  resources :board_states, :minions_in_game
end
