require_relative 'models_helper'

describe User do

  before do
    DataMapper.auto_migrate!
  end


  describe 'validation' do

    it 'should require a username' do
      user = User.create(password: 'password')
      expect( user ).not_to be_valid
      expect( user.errors).to include(['Username must not be blank'])

      user = User.create(username: 'test', password: 'paow')
      expect( user ).to be_valid
    end

    it 'should require a password' do
      user = User.create(username: 'username')
      expect( user ).not_to be_valid
      expect( user.errors).to include(['Password must not be blank'])

      user = User.create(username: 'test', password: 'paow')
      expect( user ).to be_valid
    end

  end

end
