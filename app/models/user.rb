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
      Pony.mail({
        :to => user.email,
        :subject => 'Your Swink password has been reset!',
        :body => "Your new password is: #{password} (change this the next time you log in)",
        :via => :smtp,
        :via_options => {
          :address              => 'smtp.gmail.com',
          :port                 => '587',
          :enable_starttls_auto => true,
          :user_name            => 'swinknoreply@gmail.com',
          :password             => 'swinkyio1337',
          :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
          :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
        }
      })
      app.redirect('/')
    else
      app.redirect('/forgot_password_inv')
    end
  end
end
