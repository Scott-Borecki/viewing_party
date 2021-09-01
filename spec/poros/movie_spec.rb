require "rails_helper"

RSpec.describe Movie, :vcr do
  let(:attrs) { MovieService.search_by_id(550) }
  let(:movie) { Movie.new(attrs) }

  it "exists" do
    expect(movie).to be_a Movie
    expect(movie.id).to eq(attrs[:id])
    expect(movie.title).to eq(attrs[:title])
    expect(movie.vote_average).to eq(attrs[:vote_average])
    expect(movie.runtime).to eq(attrs[:runtime])
    expect(movie.overview).to eq(attrs[:overview])

    expect(movie.genres).to be_an Array
    expect(movie.genres.first).to be_a String
  end

  describe 'instance methods' do
    describe '#poster' do
      it 'returns the poster in the movie' do
        expect(movie.poster).to be_a Poster
      end
    end

    describe '#cast' do
      it 'returns the actors in the movie' do
        expect(movie.cast).to be_an Array
        expect(movie.cast.first).to be_an Actor
      end
    end

    describe '#reviews' do
      it 'returns the reviews of the movie' do
        expect(movie.reviews).to be_an Array
        expect(movie.reviews.first).to be_a Review
      end
    end
  end
end
