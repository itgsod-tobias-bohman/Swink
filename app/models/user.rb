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
    User.create(username: params['username'],
                password: params['password'])
  end
end
