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

 describe 'user lists' do
    xit 'has a list of existing users which links to the users dashboard' do
      user1 = User.create!(name: 'Deannah', email: 'rockyhorrorfan@gmail.com', password: 'thebestoneyet')
      user2 = User.create!(name: 'Sai', email: 'movieluvr55@hotmail.com', password: 'thecoolest')

      visit root_path

      expect(page).to have_link 'Deannah'
      expect(page).to have_link 'Sai'
      expect(page).to have_content 'movieluvr55@hotmail.com'

      within "#user-#{user1.id}" do
        expect(page).to have_content('rockyhorrorfan@gmail.com')
        click_link 'Deannah'
      end
      expect(current_path).to eq('/dashboard')
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
      user1 = User.create!(name: 'Deannah', email: 'rockyhorrorfan@gmail.com', password: 'thebestoneyet')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)

      visit root_path

      click_link('Log Out')
      expect(current_path).to eq(root_path)
      expect(page).to have_link('Log In')
    end
  end
end
