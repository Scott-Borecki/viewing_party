require 'rails_helper'

describe Event, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:movie_id) }
    it { should validate_presence_of(:date_time) }
    it { should validate_presence_of(:duration) }

    # API DOCS: https://developers.themoviedb.org/3/movies/get-movie-details # movie_id is an integer
    it { should validate_numericality_of(:movie_id) }
    it { should validate_numericality_of(:duration) }

    # OTHER VALIDATIONS:
    # => date_time == datetime # perhaps we could validate format? but no validation available for datetime
    # => duration >= movie_duration # perhaps need a custom validation for this one
  end

  describe 'relationships' do
    it { should belong_to(:user) }
    it { should have_many(:invitations) }
    it { should have_many(:users).through(:invitations) }
  end
end
