require 'rails_helper'

RSpec.describe MovieFacade do
  describe "class methods" do
    describe ".search_by_title" do
      it "returns an array of movie objects", :vcr do
        movies = MovieFacade.search_by_title('Shining')

        expect(movies).to be_an Array
        expect(movies.first).to be_a Movie

        movies.each do |movie|
          expect(movie.title).to include('Shining')
        end
      end
    end

    describe ".search_by_id" do
      it "returns a movie object by id", :vcr do
        movie = MovieFacade.search_by_id(550)

        expect(movie).to be_a Movie
        expect(movie.id).to eq(550)
      end
    end

    describe ".cast_members_by_movie_id" do
      it "returns an array of cast member objects by movie id", :vcr do
        cast_members = MovieFacade.cast_members_by_movie_id(550)

        expect(cast_members).to be_an Array
        expect(cast_members.first).to be_an Actor
      end
    end

    describe ".reviews_by_movie_id" do
      it "returns an array of review objects by id", :vcr do
        reviews = MovieFacade.reviews_by_movie_id(550)

        expect(reviews).to be_an Array
        expect(reviews.first).to be_a Review
      end
    end
  end
end
