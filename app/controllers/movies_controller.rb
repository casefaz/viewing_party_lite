class MoviesController < ApplicationController

  def index
    @user = current_user
    # binding.pry
    if params[:search].present?
      @movies = MovieFacade.film_search(params[:search])
    else
      @movies = MovieFacade.top_rated_array
    end
  end

  def show
    @user = current_user
    @movie = MovieFacade.movie_id_search(params[:id])
    @movie_cast = MovieFacade.movie_cast(params[:id]).first(10)
    @movie_review = MovieFacade.movie_reviews(params[:id])
  end
end

