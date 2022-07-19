require 'rails_helper'

RSpec.describe 'Welcome Index', type: :feature do
  describe 'landing page' do
    it 'has the title of the application' do
      visit root_path

      expect(page).to have_content('Viewing Party Lite')
    end

    it 'has a button to create a new user' do
      visit root_path
      expect(page).to have_button('Create a New User')

      click_button 'Create a New User'
      expect(current_path).to eq('/register')
    end

    it 'has a link to go back to the landing page' do
      visit root_path

      click_link 'Home'
      expect(current_path).to eq(root_path)
    end
  end

  describe 'login link' do 
    it 'has a link to login' do 
      visit root_path

      expect(page).to have_link('Log In')
      click_link('Log In')
      expect(current_path).to eq('/login')
    end
  end

  describe 'logout link' do 
    it 'has a link to log out if user is logged in' do 
      user1 = User.create!(name: 'Deannah', email: 'rockyhorrorfan@gmail.com', password: 'thebestoneyet')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)

      visit root_path

      expect(page).to have_link('Log Out')
    end

    it 'logs out the user' do 
      user = User.create(name: 'RubyLover', email: 'rubydooby@rails.com', password: 'rubyrocks')
      visit root_path

      click_link('Log In')
      expect(current_path).to eq('/login')
      fill_in 'Email', with: 'rubydooby@rails.com'
      fill_in 'Password', with: 'rubyrocks'
      click_on 'Log In'

      visit root_path

      click_link('Log Out')
      expect(current_path).to eq(root_path)
      expect(page).to have_link('Log In')
    end
  end

  describe 'authentication' do 
    it 'doesnt have a list of users on the landing page' do 
      user1 = User.create!(name: 'Deannah', email: 'rockyhorrorfan@gmail.com', password: 'thebestoneyet')
      user2 = User.create!(name: 'Sai', email: 'skunkwars@hotmail.com', password: 'maythebestskunkwin')

      visit root_path

      expect(page).to have_content('Log In')
      expect(page).to_not have_content(user1.email)
      expect(page).to_not have_content(user2.email)
    end

    it 'shows only emails if user is logged in' do 
      user1 = User.create!(name: 'Deannah', email: 'rockyhorrorfan@gmail.com', password: 'thebestoneyet')
      user2 = User.create!(name: 'Sai', email: 'skunkwars@hotmail.com', password: 'maythebestskunkwin')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)

      visit root_path

      expect(page).to have_content(user1.email)
      expect(page).to have_content(user2.email)
      expect(page).to_not have_link(user1.name)
    end

    it 'cant get past the landing page without logging in' do 
      user1 = User.create!(name: 'Deannah', email: 'rockyhorrorfan@gmail.com', password: 'thebestoneyet')
      visit root_path

      expect(page).to have_content('Log In')
      visit '/dashboard'
      expect(current_path).to eq(root_path)
      expect(page).to have_content('Please Log In First')
    end
  end
end
