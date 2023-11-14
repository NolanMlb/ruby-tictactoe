module UI
  module Console
    class CreateGame
      include AppContainer::Deps[player_repository: 'tictactoe.player_in_sql_repository']
      include AppContainer::Deps[game_repository: 'tictactoe.game_in_sql_repository']

      def run
        player_x = player_setup("X")
        player_o = player_setup("O")

        if player_x == player_o
          puts "Player X and Player O are the same"
          puts "Chose again"

          return run
        end

        game = game_repository.create(player_x, player_o)

        UI::Console::Game.new(game, game_repository).run
      end

      private

      def player_setup(role)
        setup_choice = nil

        while setup_choice.nil?
          puts "Player #{role}:"
          puts "1 - Create player"
          puts "2 - Choose player"
          print "Your choice: "

          user_input = get_user_input
          next unless user_input =~ /\A-?\d+\z/

          setup_choice = user_input.to_i
        end

        case setup_choice
        when 1 then create_player
        when 2 then choose_player
        else player_setup(role)
        end
      end

      def create_player
        player_name = nil

        while player_name.nil?
          puts
          print "Player name: "
          player_name = get_user_input
        end

        player_repository.create(player_name)
      end

      def choose_player
        player = nil
        players = player_repository.all

        while player.nil?
          puts "======="
          puts "Player List"
          puts "======="
          puts
          players.each_with_index do |player, i|
            puts "#{i + 1} - #{player.name}"
          end

          print "Player number: "
          input = get_user_input

          next unless input =~ /\A-?\d+\z/

          player_index = input.to_i - 1

          player = players[player_index]
        end

        player
      end

      def get_user_input
        gets&.chomp
      end
    end
  end
end
