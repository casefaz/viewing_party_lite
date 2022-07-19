require 'rails_helper'

RSpec.describe 'Movie Index Page', type: :feature do 
  describe 'title section' do 
    it 'has a list of the top rated films with a vote count', :vcr do 
      user1 = User.create!(name: 'Andrew', email: 'concertenthusiast@musac.org', password: '150concerts')
      user2 = User.create!(name: 'Sai', email: 'allthethings@hottooob.com', password: 'hotdog')
      
      visit user_movies_path(user1.id)
      expect(page.all('.movies').count).to eq(20)

      within '.topMovies' do 
        expect(page).to have_content('Spirited Away')
        expect(page).to have_content('Pulp Fiction')
        expect(page).to have_content(8.7)
      end
    end
  end

  describe 'link to discovery page' do 
    it 'links back to the discovery page', :vcr do 
      user1 = User.create!(name: 'Andrew', email: 'concertenthusiast@musac.org', password: '150concerts')
      
      visit user_movies_path(user1.id)
      
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)
      click_link 'Discover Page'
      expect(current_path).to eq('/discover')
      expect(page).to have_content("#{user1.name}'s Discover Page")
    end
  end

  describe 'search section' do 
    it 'can find partial matches', :vcr do 
      user1 = User.create!(name: 'Andrew', email: 'concertenthusiast@musac.org', password: '150concerts')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)

      visit '/discover'
      
      fill_in :search, with: 'spirit'
      click_on 'Find Movies'
      expect(current_path).to eq(user_movies_path(user1.id))
      expect(page).to have_content('Teen Spirit')
      expect(page).to have_content('Spirit Untamed')
      expect(page).to have_content('Blithe Spirit')
      expect(page).to_not have_content('The Green Mile')
    end
  end
end