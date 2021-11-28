class MoviesController < ApplicationController

    def index

      #ordenar os registros por ano
      @movies = Movie.all.order(:year)


      #filtrar os registro por ano, genero e país
      filter_by_year if params[:year]
      filter_by_genre if params[:genre]
      filter_by_country if params[:country]

      render json: @movies, except: [:created_at, :updated_at]

    end
  
  
  #criar os registro no banco de dados com um endpoint diferente que foi pedido
  def create


    require "CSV"
    require 'time'
    require 'date'

    file = 'tmp/netflix_titles.csv'
    saida = CSV.read(file)

    def date_modify(date_list)

        Date.parse(date_list).to_s

    end

    #esse variavel é para pegar todos os registros apartir do indice 1
    final = saida[1..]


    # esse if verifica se há dados existentes no banco, poderia registrar Movie.exists?(id)
    if Movie.exists?

     @movies = ["O Arquivo csv já foi registrado no banco de dados"]

    else
      
      for i in final do

        @movies = Movie.create!(title: i[2], genre: i[1], year: i[7], country: i[5], published_at: date_modify(i[6]), description: i[10])
        
      end

    end

    render json: @movies
    
  end

  #filtros
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
