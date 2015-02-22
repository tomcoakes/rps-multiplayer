require 'sinatra/base'
require_relative './lib/game'
require_relative './lib/computer'
require_relative './lib/player'

class RPS < Sinatra::Base
  
  enable :sessions

  game = Game.new
  computer = Computer.new

  get '/' do
    erb :index
  end

  post '/game' do
    name = params[:name]
    if name.empty?
      erb :index
    else
      @player = Player.new(name)
      if game.players.empty?
        session[:player_one] = @player
      else
        session[:player_two] = @player
      end
      game.add_player(@player)
      erb :game
    end
  end

  get '/outcome' do
    if session[:player_one]
      game.players[0].weapon = params[:weapon].to_sym
      session[:player_one].weapon = game.players[0].weapon
      @p1_weapon = session[:player_one].weapon
    elsif session[:player_two]
      game.players[1].weapon = params[:weapon].to_sym
      session[:player_two].weapon = game.players[1].weapon
      @p2_weapon = session[:player_two].weapon
    end

    while game.players[0].weapon == nil || game.players[1].weapon == nil do
      "Waiting for the other player to take their turn"
    end

    if session[:player_one]
      @player = game.players[0]
      @opponent = game.players[1]
      @opponents_weapon = game.players[1].weapon
    elsif session[:player_two]
      @player = game.players[1]
      @opponent = game.players[0]
      @opponents_weapon = game.players[0].weapon
    end
    
    @winner = game.winner

      erb :outcome
  end

  get '/game' do
    @player = game.players[1]
    @computer = game.players[0]
    erb :game
  end

  run! if app_file == $0
end
