require 'rails_helper'

# When a user visits the root path they should be on the welcome page which includes:
#
#  Welcome message
#  Brief description of the application
#  Button to Log in
#  Link to Registration
#
# Details: Implement basic auth in the application allowing a user to log in with an email and password. The password should be stored in the database using bcrypt.

RSpec.describe 'User registration form' do
  it 'creates new user, happy path' do
    visit root_path

    registration_link = 'Register as a User'

    click_on registration_link

    expect(page).to have_current_path('/registration')

    email = 'funbucket13'
    password = 'test'
    submit = 'Register'

    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password

    click_on submit

    expect(page).to have_current_path('/dashboard')

    within '#success' do
      expect(page).to have_content("Welcome, #{email}!")
    end
  end

  it 'creates new user, sad path' do
    visit root_path

    registration_link = 'Register as a User'

    click_on registration_link

    expect(page).to have_current_path('/registration')

    email = 'funbucket13'
    password = 'test'
    submit = 'Register'

    # fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password

    click_on submit

    expect(page).to have_current_path('/registration')

    within '#failure' do
      expect(page).to have_content('Something went horribly wrong!')
    end
  end
end
