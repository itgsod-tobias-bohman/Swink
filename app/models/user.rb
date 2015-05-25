class User
  include DataMapper::Resource

  property :id, Serial
  property :username, String, required: true, unique: true
  property :email, String, required: false, unique: false
  property :password, BCryptHash, required: true
  property :notifications, Boolean, default: false

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

  def change_email(params, app)
    if password == params['password'] && params['email'] == params['email-confirmation']
      update(:email => params['email'])
    end
  end

  def change_password(params, app)
    if password == params['password-old'] && params['password'] == params['password-confirmation']
      update(:password => params['password'])
    end
  end

  def change_notifications(params, app)
    if params['notifications'] == 'yes'
      update(:notifications => true)
    else
      update(:notifications => false)
    end
  end

  def delete_account(params, app)
    if password == params['password']
      Link.all(user: self).destroy
      self.destroy
      <<-DOC
      links = Link.all(user_id == user.id)
      links.destroy
      user.destroy
      DOC
    end
    app.redirect('/')
  end
end
