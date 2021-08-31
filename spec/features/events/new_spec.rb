require 'rails_helper'

RSpec.describe 'new viewing party event page' do
  describe 'as an authenticated user', :vcr do
    let(:email) { 'funbucket13' }
    let(:password) { 'test' }
    let(:user) { User.create(email: email, password: password) }
    let!(:followee1) { user.followees.create(email: 'email2', password: 'test2') }
    let!(:followee2) { user.followees.create(email: 'email3', password: 'test3') }
    let!(:followee3) { user.followees.create(email: 'email4', password: 'test4') }
    let(:movie) { MovieFacade.search_by_id(550) }
    let(:date) { 'January 1, 2022' }
    let(:month) { 'January' }
    let(:day) { '1' }
    let(:year) { '2022' }
    let(:start_time) { '5:00 PM' }
    let(:hours) { '17' }
    let(:minutes) { '00' }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    describe 'when I visit the new viewing party event page' do
      before { visit new_movie_event_path(movie.id) }

      it 'displays the movie title name' do
        expect(page).to have_content(movie.title)
      end

      it 'displays a form to create a new viewing party' do
        expect(page).to have_field(:duration, with: movie.runtime)
        expect(page).to have_field('date[when(1i)]')
        expect(page).to have_field('date[when(2i)]')
        expect(page).to have_field('date[when(3i)]')
        expect(page).to have_field('time[start_time(4i)]')
        expect(page).to have_field('time[start_time(5i)]')
        user.followees.each do |followee|
          expect(page).to have_unchecked_field("invitations[#{followee.email}]")
        end

        expect(page).to have_button('Create Viewing Party')
      end

      context 'when I fill in the form with valid inputs and click "Create Viewing Party"' do
        before do
          select year, from: 'date[when(1i)]'
          select month, from: 'date[when(2i)]'
          select day, from: 'date[when(3i)]'
          select hours, from: 'time[start_time(4i)]'
          select minutes, from: 'time[start_time(5i)]'

          user.followees[0..1].each do |followee|
            check "invitations[#{followee.email}]"
          end

          click_button 'Create Viewing Party'
        end

        it 'redirects me to the dashboard' do
          expect(page).to have_current_path(dashboard_path)
        end

        it 'displays the new event in the Viewing Parties section' do
          user.reload
          visit '/dashboard'

          within '#events' do
            expect(page).to have_content(movie.title)
            expect(page).to have_content(date)
            expect(page).to have_content(start_time)
            expect(page).to have_content("Host: #{user.email}")
            user.followees[0..1].each do |followee|
              expect(page).to have_content(followee.email)
            end
          end
        end

        it 'displays the new event on the invitees dashboard' do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user.followees.first)

          visit dashboard_path

          within '#events' do
            expect(page).to have_content(movie.title)
            expect(page).to have_content(date)
            expect(page).to have_content(start_time)
            expect(page).to have_content("Host: #{user.email}")
            user.followees[0..1].each do |followee|
              expect(page).to have_content(followee.email)
            end
          end
        end
      end

      context 'when I fill in the form with a duration less than the movie runtime and click "Create Viewing Party"' do
        before do
          fill_in :duration, with: (movie.runtime - 1)

          user.followees[0..1].each do |followee|
            check "invitations[#{followee.email}]"
          end

          click_button 'Create Viewing Party'
        end

        it 'renders the new event page' do
          expect(page).to have_current_path(new_movie_event_path(movie.id))
        end

        it 'displays an error flash message' do
          flash_error = "Error: Duration can't be less than the movie runtime"
          expect(page).to have_content(flash_error)
        end
      end

      context 'when I fill in the form with an invalid duration and click "Create Viewing Party"' do
        before do
          fill_in :duration, with: 'some duration'

          user.followees[0..1].each do |followee|
            check "invitations[#{followee.email}]"
          end

          click_button 'Create Viewing Party'
        end

        it 'renders the new event page' do
          expect(page).to have_current_path(new_movie_event_path(movie.id))
        end

        it 'displays an error flash message' do
          flash_error = "Error: Duration is not a number, Duration can't be less than the movie runtime"
          expect(page).to have_content(flash_error)
        end
      end
    end
  end

  # OTHER EDGE CASES TO TEST:
  #   - User has no friends; no checkboxes should be displayed.
  #       Can they still make an event?
  #   - Date/time is in the past.  Should return to new Event page and display
  #       flash message.
end
