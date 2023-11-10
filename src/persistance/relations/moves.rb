module Persistance
  module Relations
    class Moves < ROM::Relation[:memory]
      gateway :memory

      schema(:moves) do
        attribute :game_id, Types::String
        attribute :x_pos, Types::Integer
        attribute :y_pos, Types::Integer
        attribute :movement_index, Types::Integer
      end

      def for_games(_assoc, games)
        restrict(game_id: games.map { |game| game[:id] })
      end
    end
  end
end
