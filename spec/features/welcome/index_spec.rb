require 'rails_helper'

RSpec.describe 'Welcome Index' do 
  describe 'landing page' do
    it 'has the title of the application' do 
      visit root_path

      expect(page).to have_content('Viewing Party Lite')
    end 

    it 'has a button to create a new user' do 
      visit root_path
      expect(page).to have_button('Create a New User')

      click_button "Create a New User"
      expect(current_path).to eq("/register")
    end

    it 'has a list of existing users which links to the users dashboard' do 
      user1 = User.create!(name: 'Deannah', email: 'rockyhorrorfan@gmail.com')
      user2 = User.create!(name: 'Sai', email: 'movieluvr55@hotmail.com')

      visit root_path

      expect(page).to have_link "#{user1.name}"
      expect(page).to have_link "#{user2.name}"
      expect(page).to have_content "#{user2.email}"

      within "#user-#{user1.id}" do
        expect(page).to have_content(user1.email)
        click_link "#{user1.name}"
      end
      expect(current_path).to eq(user_path(user1.id))
    end

    it 'has a link to go back to the landing page' do 
      visit root_path

      click_link "Home"
      expect(current_path).to eq(root_path)
    end
  end
end