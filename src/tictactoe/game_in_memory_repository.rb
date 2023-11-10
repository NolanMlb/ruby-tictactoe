module TicTacToe
  class GameInMemoryRepository < ROM::Repository[:games]
    include AppContainer::Deps['persistance.container']

    def all
      games.to_a
    end

    def ongoing
      games.ongoing.combine(:moves, :player_o, :player_x).to_a
    end

    def find(id)
      raw_game = games.by_pk(id).combine(:moves).one

      game = TicTacToe::Game.new_game(raw_game.id)

      raw_game.moves.sort_by(&:movement_index).each do |move|
        game.play_turn(move.y_pos, move.x_pos)
      end

      game
    end

    def insert_move(game, row, col)
      moves.command(:create).call({
        game_id: game.id,
        x_pos: col,
        y_pos: row,
        movement_index: game.movement_index,
      })
    end

    def win_game(game)
      current_game = games.by_pk(game.id).one

      # Need to use the container version because of a bug
      AppContainer['persistance.container'].relations.games.by_pk(game.id).command(:update).call({
        winner: current_game.player_x_id,
        status: 'finished'
      })
    end

    def draw_game(game)
      AppContainer['persistance.container'].relations.games.by_pk(game.id).command(:update).call({
        winner: nil,
        status: 'finished',
      })
    end

    def create(player_x, player_o)
      game = Game.new_game

      games.command(:create).call({
        id: game.id,
        player_x_id: player_x.id,
        player_o_id: player_o.id,
        status: 'ongoing',
        winner: nil,
      })

      game
    end
  end
end
