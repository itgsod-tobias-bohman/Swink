class Link
  include DataMapper::Resource

  property :id, Serial
  property :title, String, required: true, default: "Swink saved link!"
  property :link, String, required: true, length: 255
  property :tag, String, default: ""
  property :secret, Boolean, default: false
  property :created_at, DateTime

  belongs_to :user

  def self.addlink(params, user, title, app)
    @tag = ''
    @tag = params['tag'] if params['tag'].length > 0
    @secret = false
    @secret = true if params['secret'] == 'on'
    Link.create(title: title,
                link: params['link'],
                tag: @tag,
                secret: @secret,
                user_id: user.id)
  end

  def self.removeLink(id, user, app)
    link = Link.get(id)
    if link.user_id == user
      link.destroy!
    else
      app.redirect '/404'
    end
  end
end
