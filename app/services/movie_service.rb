class MovieService
  # TODO: update so 40 results are returned

  def self.search_by_title(search)
    response = conn.get('/3/search/movie') do |req|
      req.params['query'] = search
    end

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new(url: 'https://api.themoviedb.org') do |req|
      req.params['api_key'] = ENV['movie_api_key']
      req.adapter Faraday.default_adapter                   # Check if this is necessary
    end
  end
end
