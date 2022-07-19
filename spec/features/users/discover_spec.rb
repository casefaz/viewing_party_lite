require 'rails_helper'

RSpec.describe 'Discover Page', type: :feature do
  describe 'correct user id' do
    it 'has is the same user id from the dashboard' do
      user1 = User.create!(name: 'Parker', email: 'mangaforever@hootube.net', password: 'mangaforever')
      user2 = User.create!(name: 'Jim', email: 'musk42@trenches.org', password: 'malort')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)

      visit '/discover'

      expect(page).to have_content("Discover Page")
    end
  end 

  describe 'top rated movies button' do 
    it 'has button to discover top rated movies', :vcr do
      user1 = User.create!(name: 'Parker', email: 'mangaforever@hootube.net', password: 'mangaforever')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)

      visit '/discover'

      expect(page).to have_button('Discover Top Rated Movies')

      click_button "Discover Top Rated Movies"
      expect(current_path).to eq(user_movies_path(user1.id))
    end
  end 

  describe 'search field' do 
    it 'has a text field to enter keyword(s) to search by movie title' do
      user1 = User.create!(name: 'Parker', email: 'mangaforever@hootube.net', password: 'mangaforever')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)

      visit '/discover'

      within '.movieSearch' do
        expect(page).to have_field('search', placeholder: 'Search by movie title')
      end 
    end

    it 'has a Button to Search by Movie Title', :vcr do
      user1 = User.create!(name: 'Parker', email: 'mangaforever@hootube.net', password: 'mangaforever')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)
      
      visit '/discover'

      within '.movieSearch' do 
        expect(page).to have_button('Find Movies')
        fill_in :search, with: 'Godfather'
        click_button 'Find Movies'
      end 
      expect(current_path).to eq(user_movies_path(user1.id))
      expect(page).to have_content('The Godfather')
      expect(page).to_not have_content('Spirited Away')
    end
  end
end
