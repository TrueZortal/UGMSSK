# frozen_string_literal: true

class BoardStatesController < ApplicationController
  def index
    @board_states = BoardState.all
  end

  # def save_state(state)
  #   BoardState.new(board: state)
  #   redirect_to root_url
  # end
end
