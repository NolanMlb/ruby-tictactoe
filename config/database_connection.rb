# database_connection.rb

require 'pg'

module DatabaseConnection
  def self.get_connection
    @db_connection ||= PG.connect(
      dbname: 'tictactoe', 
      user: 'postgres', 
      password: 'postgres', 
      host: 'localhost', 
      port: 5432
    )
  end
end
