# frozen_string_literal: true

module GameManager
  # Restarts an existing game
  class RestartGameWithAnExistingGameID < ApplicationService
    attr_reader :game_id

    def initialize(game_id)
      super()
      @game_id = game_id
    end

    def call
      game = Game.find(game_id)
      BoardState.where(game_id: game_id).destroy_all
      BoardField.where(game_id: game_id).destroy_all
      PvpPlayers.where(game_id: game_id).destroy_all
      SummonedMinion.where(game_id: game_id).destroy_all
      EventLog.where(game_id: game_id).destroy_all
      TurnTracker.where(game_id: game_id).destroy_all
      User.where(game_id: game_id).each do |user|
        user.update(game_id: '')
      end
      game.update(
        player_ids: [],
        current_turn: 0,
        current_player_id: nil,
        underway: false
      )
      game.save
      BoardState.create_board(game_id: game.id, size_of_board_edge: 8)
      game
    end
  end

  # Finds game by player id
  class FindGameIdByPlayerId < ApplicationService
    attr_reader :pvp_player_id

    def initialize(pvp_player_id)
      super()
      @pvp_player_id = pvp_player_id
    end

    def call
      PvpPlayers.find(pvp_player_id).game_id
    end
  end

  # Sets current player in game
  class SetCurrentPlayer < ApplicationService
    attr_reader :game, :player_id

    def initialize(game_id, player_id)
      super()
      @game = Game.find(game_id)
      @player_id = player_id
    end

    def call
      game.update(current_player_id: player_id)
      game.save
    end
  end

  # Removes player from game
  class RemovePlayer < ApplicationService
    attr_reader :game, :player

    def initialize(game_id, player_id)
      @game = Game.find(game_id)
      @player = PvpPlayers.find(player_id)
    end

    def call
      players = game.player_ids - [player.id]
      game.update(player_ids: players)
      game.save
    end
  end

  # Adds player to a game
  class AddPlayer < ApplicationService
    attr_reader :game, :player_id

    def initialize(game_id, player_id)
      super()
      @game = Game.find(game_id)
      @player_id = player_id
    end

    def call
      game.player_ids << player_id
      game.save
    end
  end

  # Advances the game to next turn
  class MoveToNextTurn < ApplicationService
    attr_reader :game

    def initialize(game_id)
      super()
      @game = Game.find(game_id)
    end

    def call
      turn = game.current_turn + 1
      game.update(current_turn: turn)
      game.save
    end
  end
end
