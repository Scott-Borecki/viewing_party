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
  end
end
