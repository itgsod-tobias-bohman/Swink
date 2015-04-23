class User
  include DataMapper::Resource

  property :id, Serial
  property :username, String, required: true, unique: true
  property :password, BCryptHash, required: true

  has n, :links

  def self.login(params, app)
    user = User.first(username: params['username'])
    if user && user.password == params['password']
      app.session[:user] = user.id
    end
  end

  def self.logout(app)
    app.session.destroy
  end

  def self.register(params, app)
    if params['password'] == params['confirm-password']
      User.create(username: params['username'],
                  password: params['password'])
    else
      app.redirect '/404'
    end
  end
end
