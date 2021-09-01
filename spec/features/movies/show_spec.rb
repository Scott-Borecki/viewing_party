require 'rails_helper'

RSpec.describe 'Movie Details Page' do
  include ApplicationHelper

  describe 'As an autheniticated user' do
    let(:email) { 'funbucket13' }
    let(:password) { 'test' }
    let(:user) { User.create(email: email, password: password) }
    let(:movie) { MovieFacade.search_by_id(550) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    describe 'when I visit the movie detail page', :vcr do
      before { visit "/movies/#{movie.id}" }

      it 'has a button to create a viewing party' do
        expect(current_path).to eq("/movies/#{movie.id}")
        expect(page).to have_button('Create Viewing Party for Movie')
      end

      it 'redirects user to the new event page when the button is clicked' do
        click_button('Create Viewing Party for Movie')

        expect(current_path).to eq(new_movie_event_path(movie.id))
        expect(page).to have_content(movie.title)
        expect(page).to have_field(:duration, with: movie.runtime)
      end

      it 'displays movie details' do
        expect(page).to have_content(movie.title)
        expect(page).to have_content("Vote Average: #{movie.vote_average}")
        expect(page).to have_content("Runtime: #{convert_to_hr_min(movie.runtime)}")
        expect(page).to have_content(movie.genres.join(", "))

        within "#summary" do
          expect(page).to have_content(movie.overview)
        end

        within "#cast" do
          movie.cast.each do |actor|
            expect(page).to have_content("#{actor.name} as #{actor.character}")
          end
        end

        within "#reviews" do
          expect(page).to have_content(movie.reviews.size)

          movie.reviews.each do |review|
            expect(page).to have_content(review.author)
            expect(page).to have_content(review.content.squish)
          end
        end
      end

      it 'displays movie poster' do
        expect(page).to have_content(movie.poster.image)
      end
    end
  end
end
