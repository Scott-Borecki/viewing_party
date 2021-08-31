class MoviesController < ApplicationController
  def index
    return @movies = MovieFacade.search_by_title(params[:search]) if params[:search]

    @movies = MovieFacade.top_40_movies
  end

  def show
    @movie = MovieFacade.search_by_id(params[:id])
  end

  def discover
  end
end
