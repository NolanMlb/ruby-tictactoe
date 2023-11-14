require_relative '../../config/database_connection'

module TicTacToe
    class LeaderboardInSqlRepository
      def initialize
        @db_connection = DatabaseConnection.get_connection
      end
  
      def score
        # Fetch all finished games
        finished_games = @db_connection.exec("SELECT * FROM games WHERE status = 'finished'").to_a
  
        # Fetch draw games
        draw_games = finished_games.select { |game| game['winner'].nil? }
  
        # Basic statistics
        game_count = finished_games.count
        draw_game_count = draw_games.count
  
        # Victories for each player type
        x_victories = finished_games.select { |game| game['player_x_id'] == game['winner'] }.count
        o_victories = finished_games.select { |game| game['player_o_id'] == game['winner'] }.count
  
        overall_score = Score.new(game_count, finished_games.count, draw_game_count, x_victories, o_victories)
  
        # Player-specific scores
        player_with_scores = calculate_player_scores
  
        Leaderboard.new(overall_score, player_with_scores)
      end
  
      private
  
      def calculate_player_scores
        # Fetch all games
        all_games = @db_connection.exec("SELECT * FROM games").to_a
  
        # Group games by player type
        games_played_as_x = all_games.group_by { |game| game['player_x_id'] }
        games_played_as_o = all_games.group_by { |game| game['player_o_id'] }
  
        # Calculate scores for each player type
        x_scores = games_played_as_x.transform_values do |player_all_x_games|
          calculate_player_score(player_all_x_games)
        end
  
        o_scores = games_played_as_o.transform_values do |player_all_o_games|
          calculate_player_score(player_all_o_games)
        end
  
        # Merge scores for each player type
        player_with_scores = x_scores.merge(o_scores) do |player_id, x_score, o_score|
          Score.new(
            x_score.game_count + o_score.game_count,
            x_score.finished_game_count + o_score.finished_game_count,
            x_score.draw_game_count + o_score.draw_game_count,
            x_score.x_victories + o_score.x_victories,
            x_score.o_victories + o_score.o_victories,
          )
        end
  
        player_with_scores.transform_keys! { |player_id| player_id.to_s }
      end
    end
  end
  