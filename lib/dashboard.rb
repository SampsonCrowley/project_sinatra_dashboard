require "sinatra"
require "sinatra/reloader"
require_relative "helpers/scraper"

# class Dashboard < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  helpers Scraper

  get "/" do
    erb :index
  end

  get '/search' do 
    query = params[:query]
    scrape(query)
    redirect("/results")
  end

  get '/results' do 
    results_table = load_table
    puts results_table.class
    erb :results, :locals => { :results_table => results_table }
  end
# end