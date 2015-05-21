class App < Sinatra::Base

  enable :sessions
  use Rack::Deflater

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

  not_found do
    status 404
    slim :oops
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

  post '/register' do
    user = User.register(params, self)
    redirect '/'
  end

  get '/settings' do
    slim :settings
  end

  get '/forgot_password' do
    slim :forgotpassword
  end
  #################
  # LINK SPECIFIC #
  #################
  get '/links' do
    redirect '/' if !session[:user]
    @links = Link.all(:user_id => @user.id)
    slim :links
  end

  post '/links/new' do
    page = MetaInspector.new(params['link'])
    title = page.title
    link = Link.addlink(params, @user, title, self)
    redirect back
  end

  post '/links/:id/remove' do |id|
    Link.removeLink(id, @user.id, self)
    redirect back
  end
end
