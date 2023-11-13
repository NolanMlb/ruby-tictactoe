require 'sinatra'
require 'sinatra/cross_origin'
require 'json'

get '/' do 
  "Rendez vous sur la route /morpion pour accéder au Jeu"
end

get '/morpion' do
  erb :home
end

post '/morpion' do
  puts 'Requête reçue sur /morpion'
  request.body.rewind
  data = request.body.read
  puts "Donnée brute reçue du front-end : #{data}"

  begin
    json_data = JSON.parse(data)
    donnee = json_data['donnee']
    puts "Donnée parsée du front-end : #{donnee}"
  rescue JSON::ParserError => e
    puts "Erreur de parsage JSON : #{e.message}"
    status 400 # Bad Request
    return { message: 'Erreur de parsage JSON' }.to_json
  end

  # Traitez la donnée comme vous le souhaitez

  content_type :json
  { message: 'Donnée reçue avec succès!' }.to_json
end

