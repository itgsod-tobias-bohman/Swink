require_relative 'acceptance_helper'

describe('Start page', :type => :feature) do

  before do
    DataMapper.auto_migrate!
    visit '/'
  end

  it 'responds with successful status' do
    expect( page.status_code ).to eq 200
  end

  it 'shows the title of the page', :driver => :selenium do
    expect( page ).to have_content 'Swink'
  end

  it 'logins sucessfully', :driver => :selenium do
    fill_in('username', :with => 'user')
    fill_in('password', :with => 'test_password')
    click_on('Log In')
    expect( page ).to have_content 'Swink'
  end

  it 'adds a basic link', :driver => :selenium do
    fill_in('username', :with => 'user')
    fill_in('password', :with => 'test_password')
    click_on('Log In')
    fill_in('link', :with => 'https://www.youtube.com/')
    fill_in('tag', :with => 'Video Player')
    click_button('Submit')
    click_link('links-button')
    expect( page ).to have_content 'Video Player'
  end

  it 'registers a new user', :driver => :selenium do
    click_link('Register')
    fill_in('username', :with => 'test_user')
    fill_in('email', :with => 'test_user@test.com')
    fill_in('password', :with => 'test_password')
    fill_in('confirm-password', :with => 'test_password')
    click_on('Register Now')
    expect( page ).to have_content 'Swink'
  end

end
