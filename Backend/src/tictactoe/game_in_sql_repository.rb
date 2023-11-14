require 'pg'
require 'securerandom'
require_relative '../../config/database_connection.rb'

module TicTacToe
  class GameInSqlRepository
    def initialize
        @db_connection = DatabaseConnection.get_connection
    end

    def all
      result = @db_connection.exec('SELECT * FROM games')
      result.map { |row| row } # Convert PG result to a more usable format
    end

    def ongoing
      # Assuming you have a way to define 'ongoing' games in your schema
      result = @db_connection.exec("SELECT * FROM games WHERE status = 'ongoing'")
      result.map { |row| row } # Convert PG result to a more usable format
    end

    def find(id)
      # This logic will depend on how your game and moves are stored
      # Adjust the SQL queries accordingly
      raw_game = @db_connection.exec_params("SELECT * FROM games WHERE id = $1", [id]).first
      moves = @db_connection.exec_params("SELECT * FROM moves WHERE game_id = $1 ORDER BY movement_index", [id])

      game = TicTacToe::Game.new_game(raw_game['id'])
      moves.each do |move|
        game.play_turn(move['y_pos'].to_i, move['x_pos'].to_i)
      end

      game
    end

    def insert_move(game, row, col)
      @db_connection.exec_params("INSERT INTO moves (game_id, x_pos, y_pos, movement_index) VALUES ($1, $2, $3, $4)", [game.id, col, row, game.movement_index])
    end

    def win_game(game)
      @db_connection.exec_params("UPDATE games SET winner = $1, status = 'finished' WHERE id = $2", [game.player_x_id, game.id])
    end

    def draw_game(game)
      @db_connection.exec_params("UPDATE games SET winner = NULL, status = 'finished' WHERE id = $2", [game.id])
    end

    def create(player_x, player_o)
      game = Game.new_game
      @db_connection.exec_params("INSERT INTO games (id, player_x_id, player_o_id, status, winner) VALUES ($1, $2, $3, 'ongoing', NULL)", [game.id, player_x.id, player_o.id])

      game
    end
  end
end
