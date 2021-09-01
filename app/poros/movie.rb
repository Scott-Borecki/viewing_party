class Movie
  attr_reader :id,
              :title,
              :vote_average,
              :runtime,
              :genres,
              :overview

  def initialize(attributes)
    @id           = attributes[:id]
    @title        = attributes[:title]
    @vote_average = attributes[:vote_average]
    @runtime      = attributes[:runtime]
    @genres       = attributes[:genres].nil? ? [] : attributes[:genres].map { |genre| genre[:name] }
    @overview     = attributes[:overview]
  end

  def poster
    MovieFacade.image_by_movie_id(id)
  end

  def cast
    MovieFacade.cast_members_by_movie_id(id)
  end

  def reviews
    MovieFacade.reviews_by_movie_id(id)
  end
end
