class MovieService
  def self.top_40_movies
    response1 = conn.get('/3/discover/movie')

    body1 = JSON.parse(response1.body, symbolize_names: true)

    response2 = conn.get('/3/discover/movie') do |req|
      req.params['page'] = 2
    end

    body2 = JSON.parse(response2.body, symbolize_names: true)

    body2[:results].each do |movie_hash|
      body1[:results] << movie_hash
    end

    body1
  end

  def self.trending_movies
    response1 = conn.get('/3/trending/movie/week')

    body1 = JSON.parse(response1.body, symbolize_names: true)

    response2 = conn.get('/3/trending/movie/week') do |req|
      req.params['page'] = 2
    end

    body2 = JSON.parse(response2.body, symbolize_names: true)

    body2[:results].each do |movie_hash|
      body1[:results] << movie_hash
    end

    body1
  end

  def self.search_by_title(search)
    response1 = conn.get('/3/search/movie') do |req|
      req.params['query'] = search
    end

    body1 = JSON.parse(response1.body, symbolize_names: true)

    response2 = conn.get('/3/search/movie') do |req|
      req.params['query'] = search
      req.params['page'] = 2
    end

    body2 = JSON.parse(response2.body, symbolize_names: true)

    body2[:results].each do |movie_hash|
      body1[:results] << movie_hash
    end

    body1
  end

  def self.search_by_id(movie_id)
    response = conn.get("/3/movie/#{movie_id}")

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.image_by_movie_id(movie_id)
    response = conn.get("/3/movie/#{movie_id}/images")

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
