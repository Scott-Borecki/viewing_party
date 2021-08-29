require 'rails_helper'
# Issue #6 - New Viewing Party Page
# ---------------------------------
# As an authenticated user,
# When I visit the new viewing party page,
# I should see the name of the movie title rendered above a form with the
#   following fields:
#
#   - Duration of Party with a default value of movie runtime in minutes; a
#       viewing party should NOT be created if set to a value less than the
#       duration of the movie
#   - When: field to select date
#   - Start Time: field to select time
#   - Checkboxes next to each friend (if user has friends)
#   - Button to create a party
#
# Details When the party is created, the authenticated user should be redirected
#   back to the dashboard where the new event is shown. The event should also be
#   seen by any friends that were invited when they log in.

RSpec.describe 'new viewing party event page' do
  describe 'as an authenticated user' do
    let(:email) { 'funbucket13' }
    let(:password) { 'test' }
    let(:user) { User.create(email: email, password: password) }
    let!(:followee1) { user.followees.create(email: 'email2', password: 'test2') }
    let!(:followee2) { user.followees.create(email: 'email3', password: 'test3') }
    let!(:followee3) { user.followees.create(email: 'email4', password: 'test4') }
    # TODO: Need to add 'runtime' to Movie PORO and API call
    let(:movie) { Movie.new(id: 550, title: 'Fight Club', vote_average: 8.4, runtime: 139) }
    let(:date) { 'January 1, 2022' }
    let(:start_time) { '5:00 PM' }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    describe 'when I visit the new viewing party event page' do
      # THOUGHT: The new event page is accessed through the movie details page.
      #          So ... maybe '/movie/:movie_id/event/new'?
      before { visit new_event_path(movie) }

      xit 'displays the movie title name' do
        expect(page).to have_content(movie.title)
      end

      xit 'displays a form to create a new viewing party' do
        # TODO: Need to add 'runtime' to Movie PORO and API call
        expect(page).to have_field(:duration, with: movie.runtime)
        expect(page).to have_field(:when)
        expect(page).to have_field(:start_time)

        user.followees.each do |followee|
          # TODO: Might need to confirm this is correct syntax
          expect(page).to have_unchecked_field(followee.email)
        end

        expect(page).to have_button('Create Viewing Party')
      end

      context 'when I fill in the form with valid inputs and click "Create Viewing Party"' do
        before do
          # TODO: Need to check how date input will be formatted
          fill_in :when, with: date
          # TODO: Need to check how time input will be formatted
          fill_in :start_time, with: start_time

          user.followees[0..1].each do |followee|
            check followee.email
          end

          click_button 'Create Viewing Party'

          user.reload # May or may not need this
        end

        xit 'redirects me to the dashboard' do
          expect(page).to have_current_path(dashboard_path)
        end

        xit 'displays the new event in the Viewing Parties section' do
          within '#events' do
            expect(page).to have_content(movie.title)
            expect(page).to have_content(date)
            expect(page).to have_content(start_time)
          end
        end

        xit 'displays the new event on the invitees dashboard' do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user.followees.first)

          user.followees.first.reload # May or may not need this

          visit dashboard_path

          within '#events' do
            expect(page).to have_content(movie.title)
            expect(page).to have_content(date)
            expect(page).to have_content(start_time)
          end
        end
      end

      context 'when I fill in the form with a duration less than the movie runtime and click "Create Viewing Party"' do
        before do
          fill_in :duration, with: (movie.duration - 1)
          # TODO: Need to check how date input will be formatted
          fill_in :when, with: date
          # TODO: Need to check how time input will be formatted
          fill_in :start_time, with: start_time

          user.followees[0..1].each do |followee|
            check followee.email
          end

          click_button 'Create Viewing Party'
        end

        xit 'renders the new event page' do
          # THOUGHT: The new event page is accessed through the movie details page.
          #          So ... maybe '/movie/:movie_id/event/new'?
          expect(page).to have_current_path(new_event_path(movie))
        end

        xit 'displays an error flash message' do
          flash_error = 'Please complete the form and try again.'
          expect(page).to have_content(flash_error)
        end
      end

      context 'when I fill in the form with invalid inputs and click "Create Viewing Party"' do
        before do
          fill_in :duration, with: 'some duration'
          # TODO: Need to check how date input will be formatted
          fill_in :when, with: 'some date'
          # TODO: Need to check how time input will be formatted
          fill_in :start_time, with: 'some time'

          user.followees[0..1].each do |followee|
            check followee.email
          end

          click_button 'Create Viewing Party'
        end

        xit 'renders the new event page' do
          # THOUGHT: The new event page is accessed through the movie details page.
          #          So ... maybe '/movie/:movie_id/event/new'?
          expect(page).to have_current_path(new_event_path(movie))
        end

        xit 'displays an error flash message' do
          flash_error = 'Please complete the form and try again.'
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
