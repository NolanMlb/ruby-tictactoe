module TicTacToe
  class LeaderboardInMemoryRepository < ROM::Repository[:games]
    include AppContainer::Deps['persistance.container']

    def score
      all_games = games.to_a
      finished_games = all_games.select { |game| game.status == 'finished' }
      draw_games = finished_games.select { |game| game.winner == nil }

      game_count = all_games.count
      finished_game_count = finished_games.count
      draw_game_count = draw_games.count

      x_victories = finished_games.select { |game| game.player_x_id == game.winner }.count
      o_victories = finished_games.select { |game| game.player_o_id == game.winner }.count

      score = Score.new(
        game_count,
        finished_game_count,
        draw_game_count,
        x_victories,
        o_victories,
      )

      games_played_as_x = all_games.group_by { |game| game.player_x_id  }
      games_played_as_o = all_games.group_by { |game| game.player_o_id  }


      x_scores = games_played_as_x.transform_values do |player_all_x_games|
        player_finished_games = player_all_x_games.select { |game| game.status == 'finished' }
        player_draw_games = player_finished_games.select { |game| game.winner == nil }

        player_game_count = player_all_x_games.count
        player_finished_game_count = player_finished_games.count
        player_draw_games_count = player_draw_games.count

        player_x_victories = player_finished_games.select { |game| game.player_x_id == game.winner }.count

        Score.new(
          player_game_count,
          player_finished_game_count,
          player_draw_games_count,
          player_x_victories,
          0,
        )
      end

      o_scores = games_played_as_o.transform_values do |player_all_o_games|
        player_finished_games = player_all_o_games.select { |game| game.status == 'finished' }
        player_draw_games = player_finished_games.select { |game| game.winner == nil }

        player_game_count = player_all_o_games.count
        player_finished_game_count = player_finished_games.count
        player_draw_games_count = player_draw_games.count

        player_o_victories = player_finished_games.select { |game| game.player_o_id == game.winner }.count

        Score.new(
          player_game_count,
          player_finished_game_count,
          player_draw_games_count,
          0,
          player_o_victories,
        )
      end

      player_scores = x_scores.merge(o_scores) { |key, x_score, o_score| x_score + o_score }

      players_cache = player_scores.keys.then { |ids| players.for_ids(ids) }.each_with_object({}) do |player, acc|
        acc[player.id] = player
      end

      player_with_scores = player_scores.map do |player_id, score|
        [players_cache[player_id], score]
      end

      Leaderboard.new(score, player_with_scores)
    end
  end
end
