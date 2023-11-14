require 'sinatra'
require 'sinatra/cross_origin'
require 'json'
require_relative 'models/move' 

configure do
  set :public_folder, File.dirname(__FILE__) + '/public'
end

get '/' do 
  "Rendez vous sur la route /morpion pour accéder au Jeu"
end

get '/morpion' do
  erb :home
end

post '/morpion' do
  request.body.rewind
  data = request.body.read
  puts "Donnée brute reçue du front-end : #{data}"

  begin
    posX, posY = data.split(',') # PosX et PosY a stocker dans la table game
    puts "Valeurs de posX et posY reçues du front-end : #{posX}, #{posY}"
    
  rescue StandardError => e
    puts "Erreur lors de la manipulation des données : #{e.message}"
    status 400 # Bad Request
    return { message: 'Erreur lors de la manipulation des données' }.to_json
  end

  # Traitez les valeurs de posX et posY comme vous le souhaitez

  content_type :json
  { message: 'Donnée reçue avec succès!' }.to_json
end


