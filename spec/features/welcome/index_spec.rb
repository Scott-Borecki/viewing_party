require 'rails_helper'

RSpec.describe 'welcome index page' do
  it 'displays the welcome page' do
    visit root_path

    

    welcome_message = 'Welcome to Viewing Party!'
    description = 'This is the Viewing Party. Create an event, invite your friends, watch a movie together, have a great time, and repeat!'
    button_text = 'Log In'
    registration_link = 'Register as a User'

    expect(page).to have_current_path(root_path)
    expect(page).to have_content(welcome_message)
    expect(page).to have_content(description)
    expect(page).to have_button(button_text)
    expect(page).to have_link(registration_link)
  end
end
