require 'rails_helper'

describe MovieService do
  context "class methods" do
    context ".search_by_title" do
      it "returns movie data", :vcr do
        search = MovieService.search_by_title('Shining')
        expect(search).to be_a Hash
        expect(search[:results]).to be_an Array
        movie_data = search[:results].first

        expect(movie_data).to have_key :id
        expect(movie_data[:id]).to be_an(Integer)

        expect(movie_data).to have_key :title
        expect(movie_data[:title]).to be_a(String)

        expect(movie_data).to have_key :vote_average
        expect(movie_data[:vote_average]).to be_a(Float)
      end
    end

    context ".conn" do
      it "does something", :vcr do
        conn = MovieService.conn
        expect(conn).to be_a Faraday::Connection
        expect(conn.params.keys).to include('api_key')
        expect(conn.params['api_key']).to eq(ENV['movie_api_key'])
      end
    end
  end
end
