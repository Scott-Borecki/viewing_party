class MoviesController < ApplicationController
  def index
    if params[:search]
      @movies = MovieFacade.search_by_title(params[:search])

      render 'movies/index'
    end
  end

  def discover
  end
end
