require 'pg'

begin
  # Connexion à la base de données
  connection = PG.connect(dbname: 'morpion', user: 'ton_utilisateur', password: 'ton_mot_de_passe', host: 'localhost', port: 5432)

  # Exécuter une requête SQL
  result = connection.exec("SELECT * FROM ta_table;")

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