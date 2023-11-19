require 'sinatra'
require 'sinatra/cross_origin'
require 'json'
require 'sinatra'
require 'sinatra/activerecord'
# Change le mot de passe postgresql si nécessaire
set :database, {adapter: 'postgresql', database: 'TicTacToe', username: 'postgres', password: 'admin'}

require_relative 'models/move'
require_relative 'models/game'
require_relative 'models/player'
require_relative './database/initialisationDb'

configure do
  set :public_folder, File.dirname(__FILE__) + '/public'
  conn = DatabaseConnector.connect
end

get '/' do
  @games = Game.all
  @players = Player.all

  erb :home
  # "Rendez vous sur la route /morpion pour accéder au Jeu"
end

get '/games/:id' do
  game_id = params[:id]
  @game = Game.find_by(id: game_id)

  if @game
    erb :game

  else
    status 404 # Not Found
    { message: "Jeu non trouvé avec l'ID #{game_id}" }.to_json
  end
end

post '/games' do
  request.body.rewind # Si nécessaire, pour lire le body de la requête
  data = JSON.parse(request.body.read)
  player1_id = data['player1']
  player2_id = data['player2']

  # Créer une nouvelle partie avec les ID de joueur
  game = Game.new(player_x_id: player1_id, player_o_id: player2_id, status: 'ongoing')

  if game.save
    # Si la partie est créée avec succès, renvoyez les détails de la partie
    status 201 # Created
    { game_id: game.id }.to_json # Retourne l'ID du jeu en format JSON
  else
    # Si la création de la partie échoue, renvoyez une erreur
    status 422 # Unprocessable Entity
    { message: 'Erreur lors de la création de la partie', errors: game.errors.full_messages }.to_json
  end
end

post '/games/:id/moves' do
  request.body.rewind
  data = request.body.read
  puts "Donnée brute reçue du front-end : #{data}"

  begin
    posX, posY, game_id = data.split(',') # Ajoutez game_id si nécessaire
    puts "Valeurs de posX, posY et game_id reçues du front-end : #{posX}, #{posY}, #{game_id}"
    
    # Création et enregistrement du mouvement en base de données
    move = Move.create(x_pos: posX.to_i, y_pos: posY.to_i, game_id: game_id)
    if move.persisted?
      status 200
      return { message: 'Mouvement enregistré avec succès!' }.to_json
    else
      status 422 # Unprocessable Entity
      return { message: 'Impossible d\'enregistrer le mouvement', errors: move.errors.full_messages }.to_json
    end

  rescue StandardError => e
    puts "Erreur lors de la manipulation des données : #{e.message}"
    status 400 # Bad Request
    return { message: 'Erreur lors de la manipulation des données' }.to_json
  end
end


post '/players' do
  request.body.rewind
  data = JSON.parse(request.body.read)
  name = data['name']

  # Créer un nouveau joueur avec le nom
  player = Player.new(name: name)

  if player.save
    status 201 # Created
    return player.to_json
  else
    # Si la création du joueur échoue, renvoyez une erreur
    status 422 # Unprocessable Entity
    { message: 'Erreur lors de la création du joueur', errors: player.errors.full_messages }.to_json
  end
end