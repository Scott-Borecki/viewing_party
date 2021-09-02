require 'rails_helper'

RSpec.describe 'user dashboard page' do
  describe 'as an authenticated user' do
    let(:email) { 'funbucket13' }
    let(:password) { 'test' }
    let(:user) { User.create(email: email, password: password) }
    let(:movie) { MovieFacade.search_by_id(550) }

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

      describe 'within the viewing parties section' do
        it 'displays a viewing parties section', :vcr do
          user2 = User.create(email: 'email2', password: 'password')
          Friendship.create(followee_id: user.id, follower_id: user2.id)

          their_viewing_party = Event.create(
            user_id: user2.id,
            movie_id: 550,
            date_time: 'December 10, 2021 7:00 pm',
            duration: 139
          )
          Invitation.create(event: their_viewing_party, user: user)

          my_viewing_party = Event.create(
            user_id: user.id,
            movie_id: 550,
            date_time: 'December 11, 2021 5:00 pm',
            duration: 139
          )

          user3 = User.create(email: 'email3', password: 'password')
          user4 = User.create(email: 'email4', password: 'password')

          Friendship.create(followee_id: user3.id, follower_id: user.id)
          Friendship.create(followee_id: user4.id, follower_id: user.id)

          Invitation.create(event: my_viewing_party, user: user3)
          Invitation.create(event: my_viewing_party, user: user4)

          user.reload

          visit '/dashboard'

          expect(page).to have_css('#events')

          within "#events" do
            within "#event-#{my_viewing_party.id}" do
              expect(page).to have_link(movie.title)
              expect(page).to have_content(my_viewing_party.date_time.strftime('%A, %B %-d, %Y'))
              expect(page).to have_content(my_viewing_party.date_time.strftime('%l:%M %p'))
              expect(page).to have_content(my_viewing_party.duration)
              expect(page).to have_content(my_viewing_party.user.email)
              my_viewing_party.users.each do |guest|
                expect(page).to have_content(guest.email)
              end

              click_link my_viewing_party.movie_title.to_s

              expect(page).to have_current_path("/movies/#{my_viewing_party.movie_id}")
            end
          end

          visit '/dashboard'

          within "#events" do
            within "#event-#{their_viewing_party.id}" do
              expect(page).to have_link(movie.title)
              expect(page).to have_content(their_viewing_party.date_time.strftime('%A, %B %-d, %Y'))
              expect(page).to have_content(their_viewing_party.date_time.strftime('%l:%M %p'))
              expect(page).to have_content(their_viewing_party.duration)
              expect(page).to have_content(their_viewing_party.user.email)
              their_viewing_party.users.each do |guest|
                # TODO: Make current_user's name bold in invited list
                expect(page).to have_content(guest.email)
              end

              click_link their_viewing_party.movie_title.to_s

              expect(page).to have_current_path("/movies/#{their_viewing_party.movie_id}")
            end
          end
        end
      end
    end
  end
end
