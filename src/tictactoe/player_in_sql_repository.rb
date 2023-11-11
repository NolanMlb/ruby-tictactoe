require 'pg'
require 'securerandom'
require_relative '../../config/database_connection.rb'

module TicTacToe
  class PlayerPostgreSQLRepository
    def initialize
        @db_connection = DatabaseConnection.get_connection
    end

    def all
      result = @db_connection.exec('SELECT * FROM players')
      result.map do |row|
        # Assuming row contains columns like 'id', 'name'
        { id: row['id'], name: row['name'] }
      end
    end

    def create(name)
      id = SecureRandom.uuid
      @db_connection.exec_params('INSERT INTO players (id, name) VALUES ($1, $2)', [id, name])
      { id: id, name: name }
    end
  end
end
