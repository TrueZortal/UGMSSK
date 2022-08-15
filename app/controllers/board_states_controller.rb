# frozen_string_literal: true

class BoardStatesController < ApplicationController
  def index
    @board_states = BoardState.all
  end
end
