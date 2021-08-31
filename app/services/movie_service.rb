class MovieService
  # TODO: update so 40 results are returned

  def self.search_by_title(search)
    response = conn.get('/3/search/movie') do |req|
      req.params['query'] = search
    end

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.search_by_id(movie_id)
    response = conn.get("/3/movie/#{movie_id}")

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.cast_members_by_movie_id(movie_id)
    response = conn.get("/3/movie/#{movie_id}/credits")

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.reviews_by_movie_id(movie_id)
    response = conn.get("/3/movie/#{movie_id}/reviews")

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new(url: 'https://api.themoviedb.org') do |req|
      req.params['api_key'] = ENV['movie_api_key']
      req.adapter Faraday.default_adapter                   # Check if this is necessary
    end
  end
end
