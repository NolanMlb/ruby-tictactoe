require 'pg'
require 'securerandom'
require_relative '../../config/database_connection.rb'

module TicTacToe
  class PlayerInSqlRepository
    def initialize
        @db_connection = DatabaseConnection.get_connection
    end

    def all
      result = @db_connection.run('SELECT * FROM players')
      result.map do |row|
        # Assuming row contains columns like 'id', 'name'
        { id: row['id'], name: row['name'] }
      end
    end

    def create(name)
      id = SecureRandom.uuid
      print id
      @db_connection[:players].insert(id: id, name: name)
      { id: id, name: name }
      print 'ok'
    end 
  end
end
