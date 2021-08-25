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
end
