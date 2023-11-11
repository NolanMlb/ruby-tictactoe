module UI
  module Console
    class Main
      include AppContainer::Deps[leaderboard_repository: 'tictactoe.leaderboard_in_sql_repository']

      def run
        @running = true

        puts <<-MORPION
   __
  /  \\
 /    \\
 \\    /
  \\__/
  /  \\
 / /\\ \\
/_/  \\_\\
MORPION
        while @running
          display_menu
          handle_choice(get_user_input)
        end
      end

      private

      def display_menu
        puts "===== Menu du Morpion ====="
        puts "1. Jouer nouvelle partie"
        puts "2. Continuer une partie"
        puts "3. Score"
        puts "4. Quitter"
        print "Votre choix : "
      end

      def get_user_input
        gets&.chomp
      end

      def handle_choice(choice)
        case choice
        when '1'
          play_new_game
        when '2'
          play_game
        when '3'
          display_score
        when '4'
          quit
        else
          puts "Choix invalide. Veuillez réessayer."
        end
      end

      def play_game
        puts "Recherche d'une partie..."
        UI::Console::FindOngoingGame.new.run
      end

      def play_new_game
        puts "Création d'une partie..."
        UI::Console::CreateGame.new.run
      end

      def display_score
        puts "Affichage des scores..."

        leaderboard = leaderboard_repository.score

        UI::Console::Leaderboard.new(leaderboard).run
      end

      def quit
        puts "Merci d'avoir joué ! À bientôt."
        @running = false
      end
    end
  end
end
