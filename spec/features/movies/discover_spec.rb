require 'rails_helper'

RSpec.describe 'movie discover page' do
  describe 'as an authenticated user' do
    let(:email) { 'funbucket13' }
    let(:password) { 'test' }
    let(:user) { User.create(email: email, password: password) }
    let(:movie) { MovieFacade.search_by_id(550) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

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

        it 'displays the top 40 movies' do
          top_movies = MovieFacade.top_40_movies

          top_movies.each do |movie|
            expect(page).to have_content(movie.title)
            expect(page).to have_content(movie.vote_average)
          end
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
