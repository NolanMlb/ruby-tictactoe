# database_connection.rb

require 'pg'

module DatabaseConnection
  def self.get_connection
    @db_connection ||= Sequel.connect(ENV['DATABASE_URL'])
  end
end
