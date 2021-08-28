require "rails_helper"

RSpec.describe Movie do
  it "exists" do
    attrs = {
      id: 10,
      title: "The Shining",
      vote_average: 8.7
    }

    movie = Movie.new(attrs)

    expect(movie).to be_a Movie
    expect(movie.id).to eq(attrs[:id])
    expect(movie.title).to eq(attrs[:title])
    expect(movie.vote_average).to eq(attrs[:vote_average])
  end
end
