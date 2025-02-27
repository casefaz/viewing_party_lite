require 'rails_helper'

RSpec.describe 'New party page', type: :feature do
  before(:each) do
    @user1 = User.create!(name: 'Ana', email: 'ana@example.com', password: 'anabanana')
    @user2 = User.create!(name: 'Dana', email: 'dana@example.com', password: 'danabanana')
    @user3 = User.create!(name: 'Manolo', email: 'manolo@example.com', password: 'manolobanana')
    @movie_id = 238

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
  end

  it 'When I visit the new party page has movie title', :vcr do
    visit "/movies/#{@movie_id}/viewing_party/new"

    within '#title' do
      expect(page).to have_content("The Godfather")
    end
  end

  describe 'sad path' do
    it 'it doesnt make the party if information is missing', :vcr do
    visit "/movies/#{@movie_id}/viewing_party/new"

      within '#form' do
        fill_in :duration, with: '5'
        select 2022, from: "_date_1i"
        select "July", from: "_date_2i"
        select 10, from: "_date_3i"
        select 14, from: "_start_time_4i"
        select 36, from: "_start_time_5i"
        check "#{@user2.name}"
        check "#{@user3.name}"
        expect(page).to_not have_content(@user1.name)
        click_button('Create')
      end

      expect(current_path).to eq("/movies/#{@movie_id}/viewing_party/new")
      expect(page).to have_content("Please enter a duration that is longer than the movie runtime")
    end
  end

  describe 'happy path' do
    it 'When I fill out the form it appears on the host dashboard', :vcr do
    visit "/movies/#{@movie_id}/viewing_party/new"

      within '#form' do
        fill_in :duration, with: '175'
        select 2022, from: "_date_1i"
        select "July", from: "_date_2i"
        select 10, from: "_date_3i"
        select 14, from: "_start_time_4i"
        select 36, from: "_start_time_5i"
        check "#{@user2.name}"
        check "#{@user3.name}"
        expect(page).to_not have_content(@user1.name)
        click_button('Create')
      end

      expect(current_path).to eq('/dashboard')

      within ".hostParty" do
        expect(page).to have_content("The Godfather")
        expect(page).to have_content("Jul 10, 2022")
        expect(page).to have_content('Host: Ana')
        expect(page).to have_content('Dana')
      end
    end

    it 'shows up on the guests dashboard', :vcr do 
    visit "/movies/#{@movie_id}/viewing_party/new"

      within '#form' do
        fill_in :duration, with: '175'
        select 2022, from: "_date_1i"
        select "July", from: "_date_2i"
        select 10, from: "_date_3i"
        select 14, from: "_start_time_4i"
        select 36, from: "_start_time_5i"
        check "#{@user2.name}"
        check "#{@user3.name}"
        expect(page).to_not have_content(@user1.name)
        click_button('Create')
      end
      
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user2)
      visit '/dashboard'

      within ".invites" do
        expect(page).to have_content("The Godfather")
        expect(page).to have_content("Jul 10, 2022")
        expect(page).to have_content('Host: Ana')
        expect(page).to have_content('Dana')
      end
    end

    it 'doesnt show the guest if the guest hasnt been checked', :vcr do 
    visit "/movies/#{@movie_id}/viewing_party/new"

      within '#form' do
        fill_in :duration, with: '175'
        select 2022, from: "_date_1i"
        select "July", from: "_date_2i"
        select 10, from: "_date_3i"
        select 14, from: "_start_time_4i"
        select 36, from: "_start_time_5i"
        check "#{@user3.name}"
        expect(page).to_not have_content(@user1.name)
        click_button('Create')
      end

      expect(current_path).to eq('/dashboard')

      within ".hostParty" do
        expect(page).to have_content("The Godfather")
        expect(page).to have_content("Jul 10, 2022")
        expect(page).to have_content('Host: Ana')
        expect(page).to have_content('Manolo')
        expect(page).to_not have_content('Dana')
      end
    end
  end
end
