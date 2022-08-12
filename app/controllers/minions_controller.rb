class MinionsController < ApplicationController
  def create
    @minion = @game.place(minion_params)
  end
end