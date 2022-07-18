require 'rails_helper'

RSpec.describe 'login form' do 
  it 'has a form where a user can log in' do
    user = User.create!(name: 'Kosa', email: 'gooddogs@gooddog.com', password: 'ilikebarking', password_confirmation: 'ilikebarking')
    visit '/login'

    fill_in :email, with: 'gooddogs@gooddog.com'
    fill_in :password, with: 'ilikebarking'
    click_on 'Log In'

    expect(current_path).to eq "/users/#{user.id}"
    expect(page).to have_content("Welcome, #{user.email}!")
  end
end