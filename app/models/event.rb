class Event < ApplicationRecord
  belongs_to :user

  has_many :invitations, dependent: :destroy
  has_many :users, through: :invitations

  validates :movie_id, presence: true, numericality: true
  validates :date_time, presence: true
  validates :duration, presence: true, numericality: true

  def movie_title
    MovieFacade.search_by_id(movie_id).title
  end
end
