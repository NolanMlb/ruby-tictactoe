require 'pg'

begin
  # DATABASE CONNECTION
  connection = PG.connect(dbname: 'tictactoe', user: 'postgres', password: 'postgres', host: 'localhost', port: 5434)

  # CREATE TABLES
  connection.exec("CREATE TABLE IF NOT EXISTS players (
                    id VARCHAR PRIMARY KEY,
                    name VARCHAR NOT NULL
                );
                CREATE TABLE IF NOT EXISTS games (
                    id VARCHAR PRIMARY KEY,
                    player_x_id VARCHAR NOT NULL,
                    player_o_id VARCHAR NOT NULL,
                    winner VARCHAR NULL,
                    status VARCHAR NOT NULL CHECK (status IN ('ongoing', 'finished')),

                    FOREIGN KEY (player_x_id) REFERENCES players(id),
                    FOREIGN KEY (player_o_id) REFERENCES players(id)
                );
                CREATE TABLE IF NOT EXISTS moves (
                    game_id VARCHAR NOT NULL,
                    x_pos INT NOT NULL,
                    y_pos INT NOT NULL,
                    movement_index INT NOT NULL,

                    FOREIGN KEY (game_id) REFERENCES games(id)
                );")
  result = connection.exec("SELECT * FROM games;")
  print('ok', result)

  # Traiter les résultats
  result.each do |row|
    puts "ID: #{row['id']} | Nom: #{row['nom']} | Autre_colonne: #{row['autre_colonne']}"
  end

rescue PG::Error => e
  puts "Erreur lors de la connexion à la base de données : #{e.message}"

ensure
  # Fermer la connexion à la base de données, qu'elle ait réussi ou échoué
  connection.close if connection
end