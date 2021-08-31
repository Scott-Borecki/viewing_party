require "rails_helper"

RSpec.describe Actor do
  it "exists", :vcr do
    hash = MovieService.cast_members_by_movie_id(550)
    attrs = hash[:cast].first

    actor = Actor.new(attrs)

    expect(actor).to be_an Actor
    expect(actor.name).to eq(attrs[:name])
    expect(actor.character).to eq(attrs[:character])
  end
end
