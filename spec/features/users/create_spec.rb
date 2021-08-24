require 'rails_helper'

# When a user visits the root path they should be on the welcome page which includes:
#
#  Welcome message
#  Brief description of the application
#  Button to Log in
#  Link to Registration
#
# Details: Implement basic auth in the application allowing a user to log in with an email and password. The password should be stored in the database using bcrypt.

RSpec.describe "User registration form" do
  it "creates new user" do
    visit root_path

    welcome_message = 'Welcome to Viewing Party!'
    description = 'This is the Viewing Party.  Create an event, invite your friends, watch a movie together, have a great time, and repeat!'
    button_text = 'Log In'
    registration_link = 'Register as a User'

    expect(page).to have_current_path(root_path)

    expect(page).to have_content(welcome_message)
    expect(page).to have_content(description)
    expect(page).to have_button(button_text)
    expect(page).to have_link(registration_link)

    click_on registration_link

    expect(page).to have_current_path(new_user_path)

    email = "funbucket13"
    password = "test"
    submit = 'Register'

    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password

    click_on submit

    expect(page).to have_content("Welcome, #{username}!")
  end
end
