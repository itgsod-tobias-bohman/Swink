class App < Sinatra::Base
  require 'open-uri'

  enable :sessions

  before do
    @user = User.get(session[:user]) if session[:user]
  end

  get '/debug' do
    session.inspect
  end

  get '/' do
    if session[:user]
      @loggedout = false
    else
      @loggedout = true
    end
    slim :index
  end
  #################
  # USER SPECIFIC #
  #################
  post '/login' do
    User.login(params, self)
    redirect '/'
  end

  post '/logout' do
    User.logout(self)
    redirect '/'
  end

  get '/register' do
    slim :register
  end

  post '/register' do
    user = User.register(params, self)
    redirect '/'
  end
  #################
  # LINK SPECIFIC #
  #################
  get '/links' do
    redirect '/' if !session[:user]
    slim :links
  end

  get '/links.json' do
    Link.all(:user_id => @user.id).to_json
  end

  post '/links/new' do
    page = Nokogiri::HTML(open(params['link']))
    title = page.css("title").text
    link = Link.addlink(params, @user, title, self)
    redirect back
  end

  post '/links/:id/remove' do |id|
    Link.get(id).destroy!
    redirect back
  end
end
