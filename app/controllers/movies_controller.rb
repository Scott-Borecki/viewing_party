class MoviesController < ApplicationController
  def index
    if params[:search]
      conn = Faraday.new(url: 'https://api.themoviedb.org') do |req|
        req.params['api_key'] = ENV['movie_api_key']
      end

      response = conn.get('/3/search/movie') do |req|
        req.params['query'] = params[:search]
      end

      data = JSON.parse(response.body, symbolize_names: true)
      @movies = data[:results]

      render 'movies/index'
    end
  end
end
