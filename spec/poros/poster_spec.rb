require "rails_helper"

RSpec.describe Poster do
  it "exists", :vcr do
    hash = MovieService.image_by_movie_id(550)
    attrs = hash[:posters].first

    poster = Poster.new(attrs)

    expect(poster).to be_an Poster
    expect(poster.image).to eq(attrs[:file_path])
  end
end
