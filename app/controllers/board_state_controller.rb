# frozen_string_literal: true

class BoardStateController < ApplicationController
  def export_board
    clear
    @boardstate = Board_State.new(text: @board.make_json)
    @boardstate.save
  end

  def import_board
    @boardstate = Board_State.first
  end

  def destroy
    @boardstate = Board_State.find(params[:id])
    @boardstate.destroy
  end

  def clear
    @boardstate = Board_State.all
    @boardstate.each do |boardstate|
      boardstate.destroy
    end
  end

  helper_method :export_board
end
