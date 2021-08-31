class Event < ApplicationRecord
  belongs_to :user

  has_many :invitations, dependent: :destroy
  has_many :users, through: :invitations

  validates :movie_id, presence: true, numericality: true
  validates :date_time, presence: true
  validates :duration, presence: true, numericality: true
  validate :duration_cannot_be_less_than_movie_runtime

  def movie_title
    MovieFacade.search_by_id(movie_id).title
  end

  def duration_cannot_be_less_than_movie_runtime
    return unless movie_id.present? && movie_id > 0
    if duration < MovieFacade.search_by_id(movie_id).runtime
      errors.add(:duration, "can't be less than the movie runtime")
    end
  end
end
