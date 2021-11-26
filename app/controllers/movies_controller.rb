class MoviesController < ApplicationController
  def index
    def index
      @movies = Movie.all
  
      render json: @movies
    end
  end

  def show
  end

  def create
  end
end
