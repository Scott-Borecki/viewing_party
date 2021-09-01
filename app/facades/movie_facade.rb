class MovieFacade
  def self.top_40_movies
    json = MovieService.top_40_movies

    json[:results].map do |movie_data|
      Movie.new(movie_data)
    end
  end

  def self.trending_movies
    json = MovieService.trending_movies

    json[:results].map do |movie_data|
      Movie.new(movie_data)
    end
  end

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

  def self.image_by_movie_id(movie_id)
    json = MovieService.image_by_movie_id(movie_id)
    
    Poster.new(json[:posters][0])
  end

  def self.cast_members_by_movie_id(movie_id)
    json = MovieService.cast_members_by_movie_id(movie_id)

    json[:cast][0..9].map do |actor_data|
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
