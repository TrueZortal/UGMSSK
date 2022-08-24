class Game < ApplicationRecord
  def self.add_player(game_id: nil, player_id: nil)
    game = Game.find(game_id)
    game.player_ids << player_id
    game.save
  end

  def self.set_current_player(game_id: nil, player_id: nil)
    game = Game.find(game_id)
    game.update(current_player_id: player_id)
    game.save
  end

  def self.move_game_to_next_turn(game_id: nil)
    game = Game.find(game_id)
    turn = game.current_turn + 1
    game.update(current_turn: turn)
    game.save
  end
end
