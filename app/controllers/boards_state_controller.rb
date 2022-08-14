# frozen_string_literal: true

class BoardsStateController < ApplicationController
  def index
    @boards_state = BoardState.all
  end

  def export_board
    clear
    @boardstate = BoardState.new(text: @board.make_json)
    @boardstate.save
  end

  def import_board
      @boardstate = BoardState.first
  end

  def new
    @boardstate = BoardState.new
  end

  def destroy
    @boardstate = BoardState.first
    @boardstate.destroy
  end

  def clear
    @boardstate = BoardState.all
    @boardstate.each(&:destroy)
  end

  helper_method :export_board, :import_board
end
