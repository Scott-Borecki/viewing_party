require 'rails_helper'

RSpec.describe 'Movie Details Page' do
  # As an authenticated user,
  # When I visit the movie's detail page,
  # I should see
  #
  # Button to create a viewing party
  # Details This button should take the authenticated user to the new event page
  describe 'As an autheniticated user' do
    let(:email) { 'funbucket13' }
    let(:password) { 'test' }
    let(:user) { User.create(email: email, password: password) }
    let(:movie) { Movie.new(id: 550, title: 'Fight Club', vote_average: 8.4, runtime: 139) }

    # https://api.themoviedb.org/3/movie/:movie_id
    # https://api.themoviedb.org/3/movie/:movie_id/reviews
    # https://api.themoviedb.org/3/movie/:movie_id/credits

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    describe 'when I visit the movie detail page' do
      before { visit "/movie/#{movie[:id]}" }

      it 'has a button to create a viewing party' do
        expect(current_path).to eq("/movie/#{movie[:id]}")
        expect(page).to have_button('Create Viewing Party for Movie')
      end

      it 'redirects user to the new event page when the button is clicked' do
        click_button('Create Viewing Party for Movie')

        expect(current_path).to eq("/viewing-party/new")

        within "#movie-title" do
          expect(page).to have_content(movie[:title])
          expect(page).to have_content("Movie Title: #{movie[:title]}") # does this need to be in a within block?
        end

        within "#duration-of-party" do
          expect(page).to have_content(movie.runtime)
          expect(page).to have_content("Duration of Party: #{movie[:runtime]}") # does this need to be in a within block?
        end
      end
      # And I should see the following information about the movie:
      #
      #  Movie Title
      #  Vote Average of the movie
      #  Runtime in hours & minutes
      #  Genere(s) associated to movie
      #  Summary description
      #  List the first 10 cast members (characters&actress/actors)
      #  Count of total reviews
      #  Each review's author and information
      #
      # Details: This information should come from 3 different endpoints from The Movie DB API
      visit "/movie/#{movie[:id]}"

      it 'displays movie details' do
        expect(page).to have_content(movie[:title])
        expect(page).to have_content("Vote Average: #{movie[:vote_average]}")
        expect(page).to have_content("Runtime: #{movie[:runtime]}") # convert format ex: 1 hr 54 mins

        movie[:genres].each do |genre|
          expect(page).to have_content(genre[:name]) # ex: Genre(s): Action, Adventure, Science Fiction
        end

        within "#summary" do
          expect(page).to have_content(movie[:overview])
        end

        # limit to 10
        within "#cast" do # credits enpoint
          movie[:cast].each do |actor|
            expect(page).to have_content("#{actor[:name]} as #{actor[:character]}") # ex: Sophie Turner as Jean Grey / Dark Phoenix
          end
        end

        within "#reviews" do # reviews endpoint
          expect(page).to have_content(movie[:total_results]) # ex: 8 Reviews

          movie[:results].each do |review|
            expect(page).to have_content(review[:author]) # ex: Author: movie-fan
            expect(page).to have_content(review[:content])
          end
        end
      end
    end
  end
end
