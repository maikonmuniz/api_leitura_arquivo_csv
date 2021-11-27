class MoviesController < ApplicationController
    def index

      @movies = Movie.all.order(:year)

      filter_by_year if params[:year]
      filter_by_genre if params[:genre]
      # filter_by_query if params[:country]
      # filter_by_query if params[:genre]

      render json: @movies, except: [:created_at, :updated_at]

    end
  

  def show
  end

  def create


    require "CSV"
    require 'time'
    require 'date'

    file = 'tmp/netflix_titles.csv'
    saida = CSV.read(file)

    def date_modify(date_list)

        Date.parse(date_list).to_s

    end

    final = saida[1..]

    for i in final do

      @movies = Movie.create!(title: i[2], genre: i[1], year: i[7], country: i[5], published_at: date_modify(i[6]), description: i[10])

    end

    render json: final.as_json.to_json

  end

  def filter_by_year

    @movies = @movies.where(year: params[:year])

  end

  def filter_by_genre

    @movies = @movies.where(genre: params[:genre])

  end

  def filter_by_country

    @movies = @movies.where(country: params[:country])

  end
end
