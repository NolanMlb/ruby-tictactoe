module UI
  module Console
    class FindOngoingGame
      include AppContainer::Deps[game_repository: 'tictactoe.game_in_sql_repository']

      def run
        ongoing_games = game_repository.ongoing
        ongoing_games.each.with_index do |game, i|
          puts "#{i + 1} - Joueur X #{game.player_x.name} vs Joueur O #{game.player_o.name} (#{game.moves.count} coups)"
        end

        game = choose_game(ongoing_games)


        UI::Console::Game.new(game_repository.find(game.id), game_repository).run
      end

      private

      def choose_game(ongoing_games)
        game = nil

        while game.nil?
          print "Choose a game: "

          user_input = get_user_input

          next unless user_input =~ /\A-?\d+\z/

          game_index = user_input.to_i - 1

          return ongoing_games[game_index ] if ongoing_games[game_index ]
        end
      end

      def get_user_input
        gets&.chomp
      end
    end
  end
end
