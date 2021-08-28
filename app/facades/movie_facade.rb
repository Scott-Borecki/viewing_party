class MovieFacade
  def self.search_by_title(search_by_title)
    json = MovieService.search_by_title(search_by_title)

    json[:results].map do |movie_data|
      Movie.new(movie_data)
    end
  end
end
