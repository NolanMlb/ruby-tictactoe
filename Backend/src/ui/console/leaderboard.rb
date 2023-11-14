module UI
  module Console
    class Score
      def initialize(score)
        @score = score
      end

      def run
        puts "---"
        puts "Nombre de parties: #{@score.games_count}"
        puts "Nombre de parties fini: #{@score.games_finished}"
        puts "% de parties fini: #{@score.games_finished_percentage * 100}%"
        puts "Nombre de parties nulle: #{@score.games_draw}"
        puts "% de parties nulle: #{@score.games_draw_percentage * 100}%"
      end
    end

    class Leaderboard
      def initialize(leaderboard)
        @leaderboard = leaderboard
      end

      def run
        puts "-------------"
        puts "Score général"

        Score.new(@leaderboard.general_score).run

        puts "-------------"
        puts
        puts "Score par joueur"

        @leaderboard.each_player_scores do |player, score|
          puts "|||||||||||||"
          puts "Nom du joueur: #{player.name}"
          Score.new(score).run
        end
        puts "----"
      end

    end
  end
end
