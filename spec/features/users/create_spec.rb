require 'rails_helper'

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

  it 'creates new user, sad path: no email' do
    visit root_path

    registration_link = 'Register as a User'

    click_on registration_link

    expect(page).to have_current_path('/registration')

    email = 'funbucket13'
    password = 'test'
    submit = 'Register'

    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password

    click_on submit

    expect(page).to have_current_path('/registration')

    within '#failure' do
      expect(page).to have_content('Something went horribly wrong!')
    end
  end

  it 'creates new user, sad path: no password' do
    visit root_path

    registration_link = 'Register as a User'

    click_on registration_link

    expect(page).to have_current_path('/registration')

    email = 'funbucket13'
    password = 'test'
    submit = 'Register'

    fill_in 'user[email]', with: email
    fill_in 'user[password_confirmation]', with: password

    click_on submit

    expect(page).to have_current_path('/registration')

    within '#failure' do
      expect(page).to have_content('Something went horribly wrong!')
    end
  end

  it 'creates new user, sad path: inconsistent password' do
    visit root_path

    registration_link = 'Register as a User'

    click_on registration_link

    expect(page).to have_current_path('/registration')

    email = 'funbucket13'
    password = 'test'
    password2 = 'tset'
    submit = 'Register'

    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password2

    click_on submit

    expect(page).to have_current_path('/registration')

    within '#failure' do
      expect(page).to have_content('Something went horribly wrong!')
    end
  end
end
