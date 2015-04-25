class RPS < Sinatra::Base
  
  enable :sessions

  before do
    @player = session[:me]
  end

  post '/singleplayer_game' do
    name = params[:name]
    if name.empty?
      erb :singleplayer_index
    else
      session[:game] = Game.new
      computer = Computer.new
      @player = Player.new(name)
      session[:game].add_player(computer)
      session[:game].add_player(@player)
      session[:me] = @player
      erb :singleplayer_game
    end
  end

  get '/singleplayer_outcome' do
    @computer = session[:game].players.select { |player| player.object_id != session[:me] }.first
    @player.weapon = params[:weapon].to_sym
    @computer.choose_weapon
    @winner = session[:game].winner
    erb :singleplayer_outcome
  end

  get '/singleplayer_game' do
    erb :singleplayer_game
  end

end