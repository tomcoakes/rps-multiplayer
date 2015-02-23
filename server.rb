require 'sinatra/base'
require_relative './lib/game'
require_relative './lib/computer'
require_relative './lib/player'
require_relative './app/controllers/singleplayer_controller'
require_relative './app/controllers/multiplayer_controller'

class RPS < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/app/views'
  set :public_folder, File.dirname(__FILE__) + '/public'
  enable :sessions

  get '/' do
    erb :index
  end

  get '/singleplayer_register' do
    erb :singleplayer_index
  end

  get '/multiplayer_register' do
    erb :multiplayer_index
  end

  run! if app_file == $0
end
