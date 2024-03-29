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
    @incorrect = false
    @welcome = false
    if session[:user]
      @loggedout = false
    else
      @loggedout = true
    end
    slim :index
  end

  get '/inc' do
    @incorrect = true
    @welcome = false
    @loggedout = true
    slim :index
  end

  get '/wel' do
    @incorrect = false
    @welcome = true
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

  post '/change_email' do
    @user.change_email(params, self)
    redirect '/settings'
  end

  post '/change_password' do
    @user.change_password(params, self)
    redirect '/settings'
  end

  post '/change_notifications' do
    @user.change_notifications(params, self)
    redirect '/settings'
  end

  post '/delete_account' do
    @user.delete_account(params, self)
  end

  get '/settings' do
    redirect '/' if !session[:user]
    slim :settings
  end

  get '/settings/change_email' do
    redirect '/' if !session[:user]
    @setting = 'email'
    slim :specificsetting
  end

  get '/settings/change_password' do
    redirect '/' if !session[:user]
    @setting = 'password'
    slim :specificsetting
  end

  get '/settings/change_notifications' do
    redirect '/' if !session[:user]
    @setting = 'notifications'
    slim :specificsetting
  end

  get '/settings/delete_account' do
    redirect '/' if !session[:user]
    @setting = 'delete'
    slim :specificsetting
  end

  get '/forgot_password' do
    @invalidemail = false
    redirect '/' if session[:user]
    slim :forgotpassword
  end

  get '/forgot_password_inv' do
    @invalidemail = true
    redirect '/' if session[:user]
    slim :forgotpassword
  end

  post '/forgot_password' do
    User.forgot_password(params, self)
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
