require 'rails_helper'

RSpec.describe 'welcome index page' do
  let(:welcome_message) { 'Welcome to Viewing Party!' }
  let(:description) { 'This is the Viewing Party. Create an event, invite your friends, watch a movie together, have a great time, and repeat!' }
  let(:registration_link) { 'Register as a User' }
  let(:button_text) { 'Log In' }

  before { visit root_path }

  it 'displays the welcome page' do
    expect(page).to have_current_path(root_path)
    expect(page).to have_content(welcome_message)
    expect(page).to have_content(description)
    expect(page).to have_button(button_text)
    expect(page).to have_link(registration_link)
  end

  it 'displays a log in form' do
    user = User.create(email: 'funbucket13', password: 'test')

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_on button_text

    expect(page).to have_current_path('/dashboard')
    expect(page).to have_content("Welcome, #{user.email}!")
  end

  it 'returns flash message upon invalid login, no email' do
    user = User.create(email: 'funbucket13', password: 'test')

    fill_in :password, with: user.password

    click_on button_text

    expect(page).to have_current_path(root_path)
    expect(page).to_not have_content("Welcome, #{user.email}!")

    within '#failure' do
      expect(page).to have_content('Something went horribly wrong!')
    end
  end

  it 'returns flash message upon invalid login, no password' do
    user = User.create(email: 'funbucket13', password: 'test')

    fill_in :email, with: user.email

    click_on button_text

    expect(page).to have_current_path(root_path)
    expect(page).to_not have_content("Welcome, #{user.email}!")

    within '#failure' do
      expect(page).to have_content('Something went horribly wrong!')
    end
  end

  it 'returns flash message upon invalid login, wrong password' do
    user = User.create(email: 'funbucket13', password: 'test')

    fill_in :email, with: user.email
    fill_in :password, with: "#{user.password}!"

    click_on button_text

    expect(page).to have_current_path(root_path)
    expect(page).to_not have_content("Welcome, #{user.email}!")

    within '#failure' do
      expect(page).to have_content('Something went horribly wrong!')
    end
  end

  it 'returns flash message upon invalid login, user doesnt exist' do
    fill_in :email, with: 'funbucket13'
    fill_in :password, with: 'test'

    click_on button_text

    expect(page).to have_current_path(root_path)
    expect(page).to_not have_content("Welcome, funbucket13!")

    within '#failure' do
      expect(page).to have_content('Something went horribly wrong!')
    end
  end
end
