require "CSV"
require 'time'
require 'date'

namespace :csv do
  
  desc "TODO"
  task import: :environment do


  file = 'tmp/netflix_titles.csv'
  saida = CSV.read(file)

    def date_modify(date_list)

        Date.parse(date_list).to_s

    end

    final = saida[1..]

    for i in final do

        Movie.create!(title: i[2], genre: i[1], year: i[7], country: i[5], published_at: date_modify(i[6]), description: i[10])
        
    end

  end

end
