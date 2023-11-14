module UI
  module Console
    class Game
      def initialize(game, game_repository)
        @game = game
        @game_repository = game_repository
      end

      def run
        loop do
          display_board

          case prompt_move
          in [row, col]
            result = @game.play_turn(row, col)
          in :quit
            puts "Merci, à la prochaine"
            return
          end

          case result
          when :winner
            display_board
            puts "#{@game.current_player} a gagné !"
            @game_repository.win_game(@game)
            break
          when :draw
            display_board
            puts "Match nul !"
            @game_repository.draw_game(@game)
            break
          when :quit
            puts "Merci, à la prochaine"
            break
          end
        end
      end

      def display_board
        @game.board.each do |row|
          puts row.map { |cell| cell || "-" }.join(" | ")
          puts "---------"
        end
      end

      def prompt_move
        loop do
          puts "#{@game.current_player}, à vous de jouer !"
          print "Choisissez une rangée (0-2) et une colonne (0-2) séparées par une virgule, quit pour quiter: "

          input = gets.chomp

          return :quit if input == 'quit'

          row, col = input.split(",").map(&:to_i)
          if @game.valid_move?(row, col)
            @game_repository.insert_move(@game, row, col)
            return [row, col]
          else
            puts "Mouvement non valide. Réessayez."
          end
        end
      end
    end
  end
end
