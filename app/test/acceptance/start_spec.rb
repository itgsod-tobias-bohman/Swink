require_relative 'acceptance_helper'
require_relative '../../db/seed'

describe('Start page', :type => :feature) do

  before do
    DataMapper.auto_migrate!
    Seeder.seed!
    visit '/'
  end

  it 'responds with successful status' do
    expect( page.status_code ).to eq 200
  end

  it 'shows the title of the page', :driver => :selenium do
    expect( page ).to have_content 'Swink'
  end

  it 'lets a user login with correct credentials', :driver => :selenium do
    fill_in('username', :with => 'user')
    fill_in('password', :with => 'test_password')
    click_on('Log In')
    expect( page ).to have_content 'Swink'
  end

  it 'denies access when a user tries to login with incorrect credentials', :driver => :selenium do
    fill_in('username', :with => 'anon')
    fill_in('password', :with => 'anon')
    click_on('Log In')
    expect( page ).to have_content 'Incorrect Username or Password'
  end

  it 'lets a user register when inputting correct credentials', :driver => :selenium do
    click_link('Register')
    fill_in('username', :with => 'test_user')
    fill_in('email', :with => 'test_user@test.com')
    fill_in('password', :with => 'test_password')
    fill_in('confirm-password', :with => 'test_password')
    click_on('Register Now')
    expect( page ).to have_content 'Welcome to Swink, test_user'
  end

  it 'denies a user from registering when inputting incorrect credentials', :driver => :selenium do
    click_link('Register')
    fill_in('username', :with => 'anon')
    fill_in('email', :with => '')
    fill_in('password', :with => 'test_password')
    fill_in('confirm-password', :with => 'password_test')
    click_on('Register Now')
    expect( page ).to have_content 'Incorrect Username or Password'
  end

  it 'lets a user reset their password using their email', :driver => :selenium do
    click_link('forgot-password')
    fill_in('email', :with => 'swinknoreply@gmail')
    click_on('send-password')
    expect( page ).to have_content 'Swink'
  end

  it 'lets a user add a link with a proper link & tag', :driver => :selenium do
    fill_in('username', :with => 'user')
    fill_in('password', :with => 'test_password')
    click_on('Log In')
    fill_in('link', :with => 'https://www.youtube.com/')
    fill_in('tag', :with => 'Video Player')
    click_button('submit-button')
    click_link('links-button')
    expect( page ).to have_content 'Video Player'
  end

  it 'denies a user from adding a link with an incorrect link', :driver => :selenium do
    fill_in('username', :with => 'user')
    fill_in('password', :with => 'test_password')
    click_on('Log In')
    fill_in('tag', :with => 'Video Player')
    click_button('submit-button')
    click_link('links-button')
    expect( page ).to have_no_content 'Video Player'
  end

  it 'lets a user remove a saved link', :driver => :selenium do
    fill_in('username', :with => 'user')
    fill_in('password', :with => 'test_password')
    click_on('Log In')
    click_link('links-button')
    click_on('remover')
    expect( page ).to have_no_content 'Search Engine'
  end

  it 'lets a user filter saved links', :driver => :selenium do
    fill_in('username', :with => 'user')
    fill_in('password', :with => 'test_password')
    click_on('Log In')
    fill_in('link', :with => 'https://www.youtube.com/')
    fill_in('tag', :with => 'Video Player')
    click_button('submit-button')
    click_link('links-button')
    fill_in('tag-search', :with => 'Search Engine')
    expect( page ).to have_content 'Search Engine'
    expect( page ).to have_no_content 'Video Player'
  end

  it 'lets a user share a link to facebook', :driver => :selenium do
    fill_in('username', :with => 'user')
    fill_in('password', :with => 'test_password')
    click_on('Log In')
    click_link('links-button')
    facebook_window = window_opened_by do
      click_link('share-facebook')
    end
    within_window facebook_window do
      expect( page ).to have_content 'Facebook'
    end
  end

  it 'lets a user share a link to reddit', :driver => :selenium do
    fill_in('username', :with => 'user')
    fill_in('password', :with => 'test_password')
    click_on('Log In')
    click_link('links-button')
    reddit_window = window_opened_by do
      click_link('share-reddit')
    end
    within_window reddit_window do
      expect( page ).to have_content 'reddit'
    end
  end

  it 'lets a user share a link to twitter', :driver => :selenium do
    fill_in('username', :with => 'user')
    fill_in('password', :with => 'test_password')
    click_on('Log In')
    click_link('links-button')
    twitter_window = window_opened_by do
      click_link('share-twitter')
    end
    within_window twitter_window do
      expect( page ).to have_content 'Twitter'
    end
  end

end
