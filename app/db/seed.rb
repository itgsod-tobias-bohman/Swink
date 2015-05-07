class Seeder

  def self.seed!
    self.user
    self.link
  end

  def self.user
    User.create(username: 'user',
                password: 'test_password')
  end

  def self.link
    Link.create(title: 'Google',
                link: 'http://www.google.com',
                tag: 'Search Engine',
                secret: false,
                user_id: 1)
  end

end
