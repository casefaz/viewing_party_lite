require 'rails_helper'

RSpec.describe ViewingParty, type: :model do
  describe 'relationships' do
    it { should have_many :user_viewing_parties }
    it { should have_many(:users).through(:user_viewing_parties) }
  end

  describe 'validations' do
    it { should validate_presence_of :movie_id }
    it { should validate_presence_of :duration }
    it { should validate_presence_of :date }
    it { should validate_presence_of :start_time }
  end

  it 'returns the title of the movie through the id', :vcr do 
    party1 = ViewingParty.create!(movie_id: 129, duration: 96, date: Date.new(2022,9,7), start_time: "16:00:00")

    expect(party1.movie_title).to eq('Spirited Away')
  end

  it 'returns the poster of the movie through the id', :vcr do 
    party1 = ViewingParty.create!(movie_id: 129, duration: 96, date: Date.new(2022,9,7), start_time: "16:00:00")

    expect(party1.poster_path).to eq("/39wmItIWsg5sZMyRUHLkWBcuVCM.jpg")
  end

  it 'formats the date for the party' do 
    party1 = ViewingParty.create!(movie_id: 129, duration: 96, date: Date.new(2022,9,7), start_time: "16:00:00")

    expect(party1.formatted_time).to eq(" 4:00 PM")
  end
end
