# frozen_string_literal: true

class MinionInGameController < ApplicationController
  def index
    @minionsingame = MinionInGames.all
  end
end
