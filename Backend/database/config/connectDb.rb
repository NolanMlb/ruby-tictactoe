# connectDb.rb
require 'pg'
require 'yaml'

class DatabaseConnector
  def self.connect
    conn = nil

    begin
      config = YAML.load_file('./config/database.yml')

      conn = PG.connect(
        dbname: config['development']['dbname'],
        user: config['development']['user'],
        password: config['development']['password'],
        host: config['development']['host'],
        port: config['development']['port']
      )

      puts "Connexion à la base de données réussie!"
      conn
    rescue PG::Error => e
      puts "Erreur lors de la connexion à la base de données : #{e.message}"
      # Gérer l'erreur en conséquence, par exemple, quitter le script
      exit
    end
  end
end
