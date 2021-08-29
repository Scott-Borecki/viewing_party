require 'rails_helper'

RSpec.describe 'user dashboard page' do
  describe 'as an authenticated user' do
    let(:email) { 'funbucket13' }
    let(:password) { 'test' }
    let(:user) { User.create(email: email, password: password) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    describe 'when I visit the "/dashboard" path' do
      before { visit '/dashboard' }

      it 'displays a user welcome message' do
        expect(page).to have_current_path('/dashboard')
        expect(page).to have_content("Welcome, #{email}!")
      end

      it 'displays a button to discover movies' do
        expect(page).to have_button('Discover Movies')
      end

      context 'when I click on the discover movies button' do
        before { click_button('Discover Movies') }

        it 'redirects me to the discover page' do
          expect(current_path).to eq('/discover')
        end
      end

      it 'displays a friends section' do
        within "#friends" do
          expect(page).to have_field(:friend_email)
          expect(page).to have_button('Add Friend')
        end
      end

      context 'when I add a user that exists' do
        it 'adds a friend to my friends list' do
          user2 = User.create(email: 'email2', password: 'password')
          user3 = User.create(email: 'email3', password: 'password')

          fill_in :friend_email, with: user2.email
          click_button 'Add Friend'

          expect(current_path).to eq('/dashboard')

          within "#friends" do
            expect(page).to have_content(user2.email)
            expect(page).to_not have_content(user3.email)
          end
        end
      end

      context 'when I add a user that does not exist' do
        it 'displays message "user does not exist"' do
          user2 = User.create(email: 'email2', password: 'password')
          user3 = User.create(email: 'email3', password: 'password')

          fill_in :friend_email, with: 'email4'
          click_button 'Add Friend'

          expect(current_path).to eq('/dashboard')
          expect(page).to have_content('User does not exist.')

          within "#friends" do
            expect(page).to_not have_content(user2.email)
            expect(page).to_not have_content(user3.email)
          end
        end
      end

      context 'when I have not added any friends' do
        it 'displays message "you currently have no friends"' do
          within "#friends" do
            expect(page).to have_content('You currently have no friends.')
          end
        end
      end

      context 'when I have added friends' do
        it 'displays list of all my friends' do
          user.followees.create(email: 'email2', password: 'test2')
          user.followees.create(email: 'email3', password: 'test3')
          user.followees.create(email: 'email4', password: 'test4')

          visit '/dashboard'

          within "#friends" do
            user.followees.each do |friend|
              expect(page).to have_content(friend.email)
            end
          end
        end
      end

      # As an authenticated user,
      # I should see the viewing parties I have been invited to with the following details:
      #
      # Movie Title, which links to the movie show page
      # Date and Time of Event
      # who is hosting the event
      # list of friends invited, with my name in bold
      # I should also see the viewing parties that I have created with the following details:
      #
      # Movie Title, which links to the movie show page
      # Date and Time of Event
      # That I am the host of the party
      # List of friends invited to the viewing party

      it 'displays a viewing parties section' do

      end
    end
  end
end
