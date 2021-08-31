class MoviesController < ApplicationController
  def index
    if params[:search]
      @movies = MovieFacade.search_by_title(params[:search])
    else
      @movies = MovieFacade.top_40_movies
    end
  end

  def show
    @movie = MovieFacade.search_by_id(params[:id])
  end

  def discover
  end
end
