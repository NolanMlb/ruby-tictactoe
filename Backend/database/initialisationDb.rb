require 'pg'
# initialisationDb.rb

require_relative './config/connectDb'

def create_tables(conn)
  create_players_table(conn)
  create_games_table(conn)
  create_moves_table(conn)
end

def create_players_table(conn)
  conn.exec(
    <<~SQL
      CREATE TABLE IF NOT EXISTS players (
        id VARCHAR PRIMARY KEY,
        name VARCHAR NOT NULL
      );
    SQL
  )
end

def create_games_table(conn)
  conn.exec(
    <<~SQL
      CREATE TABLE IF NOT EXISTS games (
        id VARCHAR PRIMARY KEY,
        player_x_id VARCHAR NOT NULL,
        player_o_id VARCHAR NOT NULL,
        winner VARCHAR NULL,
        status VARCHAR NOT NULL CHECK (status IN ('ongoing', 'finished')),

        FOREIGN KEY (player_x_id) REFERENCES players(id),
        FOREIGN KEY (player_o_id) REFERENCES players(id)
      );
    SQL
  )
end

def create_moves_table(conn)
  conn.exec(
    <<~SQL
      CREATE TABLE IF NOT EXISTS moves (
        game_id VARCHAR NOT NULL,
        x_pos INT NOT NULL,
        y_pos INT NOT NULL,

        FOREIGN KEY (game_id) REFERENCES games(id)
      );
    SQL
  )
end

# Connexion à la base de données
conn = DatabaseConnector.connect

# Ajout des instructions de journalisation
puts "Création des tables..."
# Création des tables
create_tables(conn)

puts "Tables créées avec succès!"

# Vérification des tables dans la base de données
result = conn.exec("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'")
puts "Tables actuellement présentes dans la base de données :"
result.each { |row| puts row['table_name'] }

# Fermeture de la connexion
conn.close

puts "Tables créées avec succès!"
