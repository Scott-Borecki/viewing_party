require 'rails_helper'

RSpec.describe 'movies page' do
  # As an authenticated user,
  # When I visit the movies page,
  # I should see the 40 results from my search,
  # I should also see the "Find Top Rated Movies" button and the Find Movies form at the top of the page.
  #
  # Details: The results from the search should appear on this page, and there should only be a maximum of 40 results. The following details should be listed for each movie.
  #
  #  Title (As a Link to the Movie Details page)
  #  Vote Average of the movie
  describe 'as an authenticated user' do
    # create user and stub current_user

    describe 'when I visit the "/movies" path' do
      before { visit '/movies' }

      it 'displays a button to discover top 40 movies' do
        expect(page).to have_button('Find Top Rated Movies')
      end

      context 'when I click on the discover top 40 movies button', :vcr do
        before { click_button('Find Top Rated Movies') }

        it 'renders the movies page with query params' do
          expect(current_path).to eq('/movies')
        end

        xit 'displays the top 40 movies' do
          # 'This' before 'That'
          # Create some fake movie data to load into test

          # expect(movie1).to appear_before(movie2)
          # expect(movie2).to appear_before(movie3)
        end
      end

      it 'displays a form to search by movie title' do
        expect(page).to have_field(:search)
        expect(page).to have_button('Find Movies')
      end

      context 'when I fill in the search form and click Find Movies', :vcr do
        let(:movie_title) { 'Shining' }
        let(:movies) { MovieFacade.search_by_title(movie_title) }

        before do
          fill_in :search, with: movie_title
          click_button 'Find Movies'
        end

        it 'renders the movies page with query params' do
          expect(current_path).to eq('/movies')
        end

        it 'diplays the movies that match the search query' do
          movies.each do |movie|
            within "#movie-#{movie.id}" do
              expect(page).to have_link(movie.title)
              expect(page).to have_content(movie.vote_average)
              expect(movie.title).to include(movie_title)
            end
          end
        end

        context 'when I click on a movie title' do
          it 'redirects me to the movie show page' do
            movie = movies.first

            click_link movie.title

            expect(page).to have_current_path(movie_path(movie.id))
          end
        end
      end
    end
  end
end
