require 'rails_helper'

RSpec.describe 'New User Form' do
  describe 'happy path' do
    it 'has a form to make a new user' do
      visit register_path

      fill_in 'Name', with: 'Zachary'
      fill_in 'Email', with: 'superbadismyfave@yahoo.com'
      fill_in 'Password', with: 'supergood'
      fill_in 'Password confirmation', with: 'supergood'
      click_on 'Register'

      last_user = User.last
      expect(current_path).to eq('/dashboard')
      expect(page).to have_content("Welcome, #{last_user.email}!")
      expect(page).to_not have_content('Cannot register, missing or repeated information')
    end
  end

  describe 'sad path' do
    it 'has an error message if information is missing' do
      visit register_path
      expect(page).to have_content('Create an Account')

      fill_in 'Name', with: ''
      fill_in 'Email', with: 'superbadismyfave@yahoo.com'
      fill_in 'Password', with: 'supergood'
      fill_in 'Password confirmation', with: 'supergood'
      click_on 'Register'

      expect(current_path).to eq(register_path)
      expect(page).to have_content("Name can't be blank")
    end

    it 'has an error message if trying to enter an in-use email' do 
      user1 = User.create!(name: 'Zach', email: 'superbadismyfave@yahoozle.com', password: 'supergood')

      visit register_path
      expect(page).to have_content('Create an Account')

      fill_in 'Name', with: 'Zachary'
      fill_in 'Email', with: 'superbadismyfave@yahoozle.com'
      fill_in 'Password', with: 'supergood'
      fill_in 'Password confirmation', with: 'supergood'
      click_on 'Register'

      expect(current_path).to eq(register_path)
      expect(page).to have_content('Email has already been taken')
    end
  end

  describe 'registration with authentication' do 
    context 'happy path' do 
      it 'has a form that includes name and password' do 
        visit '/register'

        fill_in 'Name', with: 'Pancakes'
        fill_in 'Email', with: 'pancakesoverwaffles23@gmool.com'
        fill_in 'Password', with: 'goodboy22'
        fill_in 'Password confirmation', with: 'goodboy22'
        click_on 'Register'

        current_user = User.last
        expect(current_path).to eq("/dashboard")
        expect(page).to have_content("Welcome, #{current_user.email}!")
      end
    end 

    context 'sad path' do 
      it 'has error handling for unmatched passwords' do
        visit '/register'

        fill_in 'Name', with: 'Pancakes'
        fill_in 'Email', with: 'pancakesoverwaffles23@gmool.com'
        fill_in 'Password', with: 'goodestboy22'
        fill_in 'Password confirmation', with: 'goodboy22'
        click_on 'Register'

        expect(current_path).to eq('/register')
        expect(page).to have_content("Password confirmation doesn't match Password")
      end

      it 'has error handling for missing information' do 
        visit '/register'

        fill_in 'Name', with: ''
        fill_in 'Email', with: 'pancakesoverwaffles23@gmool.com'
        fill_in 'Password', with: 'goodestboy22'
        fill_in 'Password confirmation', with: 'goodboy22'
        click_on 'Register'

        expect(current_path).to eq('/register')
        expect(page).to have_content("Name can't be blank")
      end
    end
  end
end
