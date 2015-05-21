require_relative 'models_helper'

describe Link do

  before do
    DataMapper.auto_migrate!
  end


  describe 'validation' do

    it 'should require a link' do
      link = Link.create(user_id: 1)
      expect( link ).not_to be_valid
      expect( link.errors).to include(['Link must not be blank'])

      link = Link.create(link: 'http://google.com/', user_id: 1)
      expect( link ).to be_valid
    end

    it 'should require a user_id' do
      link = Link.create(link: 'http://google.com/')
      expect( link ).not_to be_valid
      expect( link.errors).to include(['User must not be blank'])

      link = Link.create(link: 'http://google.com/', user_id: 1)
      expect( link ).to be_valid
    end

  end

end
