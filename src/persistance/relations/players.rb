module Persistance
  module Relations
    class Players < ROM::Relation[:memory]
      gateway :memory

      schema(:players) do
        attribute :id, Types::String
        attribute :name, Types::String

        primary_key :id
      end

      def for_ids(ids)
        restrict(id: ids)
      end

      def for_game_x(_assoc, games)
        restrict(id: games.map { |game| game[:player_x_id] })
      end

      def for_game_o(_assoc, games)
        restrict(id: games.map { |game| game[:player_o_id] })
      end
    end
  end
end
