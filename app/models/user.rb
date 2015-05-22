class User
  include DataMapper::Resource

  property :id, Serial
  property :username, String, required: true, unique: true
  property :email, String, required: false, unique: false
  property :password, BCryptHash, required: true

  has n, :links

  def self.login(params, app)
    user = User.first(username: params['username'])
    if user && user.password == params['password']
      app.session[:user] = user.id
      app.redirect '/'
    else
      app.redirect '/inc'
    end
  end

  def self.logout(app)
    app.session.destroy
  end

  def self.register(params, app)
    @email = ''
    @email = params['email'] if params['email'].length > 0
    if params['password'] == params['confirm-password']
      user = User.create(username: params['username'],
                  email: params['email'],
                  password: params['password'])
      app.session[:user] = user.id
      app.redirect '/wel'
    else
      app.redirect '/inc'
    end
  end

  def self.forgot_password(params, app)
    user = User.first(email: params['email'])
    if user
      password = SecureRandom.urlsafe_base64
      user.update(:password => password)
      Pony.mail :to => 'noreply@swink.io',
            :from => user.email,
            :subject => 'Your Swink password has been reset!'
            :body => "Your new password is: #{password}"
    end
  end
end
