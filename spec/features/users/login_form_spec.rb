require 'rails_helper'

RSpec.describe 'login form' do 
  context 'happy path' do 
    it 'has a form where a user can log in' do
      user = User.create!(name: 'Kosa', email: 'gooddogs@gooddog.com', password: 'ilikebarking', password_confirmation: 'ilikebarking')
      visit '/login'

      fill_in :email, with: 'gooddogs@gooddog.com'
      fill_in :password, with: 'ilikebarking'
      click_on 'Log In'

      expect(current_path).to eq "/dashboard"
      expect(page).to have_content("Welcome, #{user.email}!")
    end
  end 

  context 'sad path' do 
    it 'shows an error if the wrong credentials are entered' do
      user = User.create!(name: 'Brennan', email: 'dimension20@dnd.net', password: 'bestdmever')
      visit root_path

      click_link 'Log In'
      expect(current_path).to eq('/login')

      fill_in 'Email', with: 'dimension20@dnd.net'
      fill_in 'Password', with: 'okayestdmever'
      click_on 'Log In'

      expect(current_path).to eq('/login')
      expect(page).to have_content("Incorrect credentials")
    end
  end
end