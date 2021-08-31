require "rails_helper"

RSpec.describe Review do
  it "exists", :vcr do
    hash = MovieService.reviews_by_movie_id(550)
    attrs = hash[:results].first

    review = Review.new(attrs)

    expect(review).to be_a Review
    expect(review.author).to eq(attrs[:author])
    expect(review.content).to eq(attrs[:content])
  end
end
