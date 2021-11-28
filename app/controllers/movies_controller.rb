# frozen_string_literal: true

class MoviesController < ApplicationController
  def index
    # ordenar os registros por ano
    @movies = Movie.all.order(:year)

    # filtrar os registro por ano, genero e país
    filter_by_year if params[:year]
    filter_by_genre if params[:genre]
    filter_by_country if params[:country]

    render json: @movies, except: %i[created_at updated_at]
  end

  def file_csv(file)
    require 'CSV'
    CSV.read(file)
  end

  def modify_date(date_netflix)
    require 'time'
    require 'date'
    Date.parse(date_netflix).to_s
  end

  def indice(indice_just)
    indice_just[1..]
  end

  def validate(data)
    if Movie.exists?
      render_return = { status: :unprocessable_entity, message: 'Dados já forar cadastrados!' }
    else
      data.each do |i|
        @movies = Movie.create!(title: i[2], genre: i[1], year: i[7], country: i[5],
                                published_at: modify_date(i[6]), description: i[10])
      end

      render_return = { status: :created, message: 'Dados registrados!' }
    end

    render_return
  end

  def create
    data = file_csv('tmp/netflix_titles.csv')
    data = indice(data)
    render_return = validate(data)

    render json: render_return
  end

  # filtros
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
