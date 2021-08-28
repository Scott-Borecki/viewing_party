require 'rails_helper'

RSpec.describe 'movie discover page' do
  # As an authenticated user,
  # When I visit the '/discover' path
  # I should see
  #
  #  Button to Discover top 40 movies
  # Details When the user clicks on the top 40 button they should be taken to the movies page.
  #
  #  A text field to enter keyword(s) to search by movie title
  #  A Button to Search by Movie Title
  # Details When the user clicks on the Search button they should be taken to the movies page

  describe 'as an authenticated user' do
    # create user and stub current_user

    describe 'when I visit the "/discover" path' do
      before { visit '/discover' }

      it 'displays a button to discover top 40 movies' do
        expect(page).to have_button('Find Top Rated Movies')
      end

      context 'when I click on the discover top 40 movies button', :vcr do
        before { click_button('Find Top Rated Movies') }

        it 'redirects me to the movies page with query params' do
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

        it 'redirects me to the movies page with query params' do
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
      end
    end
  end
end
