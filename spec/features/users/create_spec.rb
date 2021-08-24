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
  xit "creates new user" do
    visit root_path

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
