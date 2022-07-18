require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relationships' do
    it { should have_many :user_viewing_parties }
    it { should have_many(:viewing_parties).through(:user_viewing_parties) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should have_secure_password }
    it { should validate_presence_of(:password) }
  end

  describe 'instance methods' do 
    xit 'can find the host' do 
      user1 = User.create!(name: 'Parker', email: 'mangaforever@hootube.net')
      user2 = User.create!(name: 'Lola', email: 'lola@example.com')

      party1 = ViewingParty.create!(movie_id: 129, duration: 96, date: Date.new(2022,9,7), start_time: "16:00:00")
      party2 = ViewingParty.create!(movie_id: 545611, duration: 175, date: Date.new(2023,4,4), start_time: "19:00:00")
      party3 = ViewingParty.create!(movie_id: 284053, duration: 145, date: Date.new(2022,10,5), start_time: "17:30:00")

      user_viewing1 = UserViewingParty.create!(user_id: user1.id, viewing_party_id: party1.id, host: true)
      user_viewing2 = UserViewingParty.create!(user_id: user1.id, viewing_party_id: party2.id, host: false)
      user_viewing3 = UserViewingParty.create!(user_id: user2.id, viewing_party_id: party3.id, host: true)

      expect(user1.party_host).to eq([party1])
      expect(user2.party_host).to eq([party3])
      expect(user1.party_host).to_not eq([party2, party3])
    end

    xit 'produces the parties where the user is NOT the host' do 
      user1 = User.create!(name: 'Parker', email: 'mangaforever@hootube.net')
      user2 = User.create!(name: 'Lola', email: 'lola@example.com')

      party1 = ViewingParty.create!(movie_id: 129, duration: 96, date: Date.new(2022,9,7), start_time: "16:00:00")
      party2 = ViewingParty.create!(movie_id: 545611, duration: 175, date: Date.new(2023,4,4), start_time: "19:00:00")
      party3 = ViewingParty.create!(movie_id: 284053, duration: 145, date: Date.new(2022,10,5), start_time: "17:30:00")

      user_viewing1 = UserViewingParty.create!(user_id: user1.id, viewing_party_id: party1.id, host: true)
      user_viewing2 = UserViewingParty.create!(user_id: user1.id, viewing_party_id: party2.id, host: false)
      user_viewing3 = UserViewingParty.create!(user_id: user2.id, viewing_party_id: party3.id, host: true)

      expect(user1.not_hosting).to eq([party2])
      expect(user1.not_hosting).to_not eq([party1])
    end
  end

  describe 'user with password' do 
    it 'has a user with attributes' do 
      user = User.create(name: 'Paige', email: 'luvisland22@hotmail.com', password: 'jaquesoradam?', password_confirmation: 'jaquesoradam?')

      expect(user).to_not have_attribute(:password)
      expect(user.password_digest).to_not eq('jaquesoradam?')
    end
  end
end
