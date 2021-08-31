class MovieFacade
  def self.search_by_title(title)
    json = MovieService.search_by_title(title)

    json[:results].map do |movie_data|
      Movie.new(movie_data)
    end
  end

  def self.search_by_id(movie_id)
    json = MovieService.search_by_id(movie_id)

    Movie.new(json)
  end

  def self.cast_members_by_movie_id(movie_id)
    json = MovieService.cast_members_by_movie_id(movie_id)

    json[:cast].map do |actor_data|
      Actor.new(actor_data)
    end
  end

  def self.reviews_by_movie_id(movie_id)
    json = MovieService.reviews_by_movie_id(movie_id)

    json[:results].map do |review_data|
      Review.new(review_data)
    end
  end
end
