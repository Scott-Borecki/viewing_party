require 'rails_helper'

describe MovieService do
  context "class methods" do
    context ".top_40_movies" do
      it "returns movie data by title search", :vcr do
        search = MovieService.top_40_movies
        expect(search).to be_a Hash
        expect(search[:results]).to be_an Array
        expect(search[:results].size).to eq(40)
        movie_data = search[:results].first

        expect(movie_data).to have_key :id
        expect(movie_data[:id]).to be_an(Integer)

        expect(movie_data).to have_key :title
        expect(movie_data[:title]).to be_a(String)

        expect(movie_data).to have_key :vote_average
        expect(movie_data[:vote_average]).to be_a(Numeric)
      end
    end

    context '.trending_movies' do
      it 'returns the trending movies this week', :vcr do
        trending = MovieService.trending_movies
        expect(trending).to be_a Hash
        expect(trending[:results]).to be_an Array
        expect(trending[:results].size).to eq(40)
        movie_data = trending[:results].first

        expect(movie_data).to have_key :id
        expect(movie_data[:id]).to be_an(Integer)

        expect(movie_data).to have_key :title
        expect(movie_data[:title]).to be_a(String)

        expect(movie_data).to have_key :vote_average
        expect(movie_data[:vote_average]).to be_a(Numeric)
      end
    end

    context ".search_by_title" do
      it "returns movie data by title search", :vcr do
        search = MovieService.search_by_title('Shining')
        expect(search).to be_a Hash
        expect(search[:results]).to be_an Array
        expect(search[:results].size).to eq(40)
        movie_data = search[:results].first

        expect(movie_data).to have_key :id
        expect(movie_data[:id]).to be_an(Integer)

        expect(movie_data).to have_key :title
        expect(movie_data[:title]).to be_a(String)

        expect(movie_data).to have_key :vote_average
        expect(movie_data[:vote_average]).to be_a(Numeric)
      end
    end

    context ".search_by_id" do
      it "returns movie data by movie id", :vcr do
        search = MovieService.search_by_id(550)
        expect(search).to be_a Hash

        expect(search).to have_key :id
        expect(search[:id]).to be_an(Integer)

        expect(search).to have_key :title
        expect(search[:title]).to be_a(String)

        expect(search).to have_key :vote_average
        expect(search[:vote_average]).to be_a(Numeric)

        expect(search).to have_key :runtime
        expect(search[:runtime]).to be_a(Integer)

        expect(search).to have_key :genres
        expect(search[:genres]).to be_a(Array)

        expect(search[:genres].first).to be_a Hash
        expect(search[:genres].first).to have_key :name
        expect(search[:genres].first[:name]).to be_a(String)

        expect(search).to have_key :overview
        expect(search[:overview]).to be_a(String)
      end

      it "returns movie image by movie id", :vcr do
        movie_img = MovieService.image_by_movie_id(550)
        expect(movie_img).to be_a Hash

        expect(movie_img).to have_key :id
        expect(movie_img[:posters]).to be_an(Array)
        expect(movie_img[:posters].first[:file_path]).to be_a(String)
      end
    end

    context ".cast_members_by_movie_id" do
      it "returns cast members by movie id", :vcr do
        cast_members = MovieService.cast_members_by_movie_id(550)
        expect(cast_members).to be_a Hash

        expect(cast_members).to have_key :cast
        expect(cast_members[:cast]).to be_an(Array)

        expect(cast_members[:cast].first).to be_a Hash

        expect(cast_members[:cast].first).to have_key :name
        expect(cast_members[:cast].first[:name]).to be_a(String)

        expect(cast_members[:cast].first).to have_key :character
        expect(cast_members[:cast].first[:character]).to be_a(String)
      end
    end

    context ".reviews_by_movie_id" do
      it "returns reviews by movie id", :vcr do
        reviews = MovieService.reviews_by_movie_id(550)
        expect(reviews).to be_a Hash

        expect(reviews).to have_key :results
        expect(reviews[:results]).to be_an(Array)

        expect(reviews[:results].first).to be_a Hash

        expect(reviews[:results].first).to have_key :author
        expect(reviews[:results].first[:author]).to be_a(String)

        expect(reviews[:results].first).to have_key :content
        expect(reviews[:results].first[:content]).to be_a(String)
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
