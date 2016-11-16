require "sinatra/base"
require_relative "helpers/scraper"

class Dashboard < Sinatra::Base

  helpers Scraper

  get "/" do
    erb :index
  end

  get '/search' do
    scrape(params[:query])
    redirect("/results")
  end

  get '/results' do
    results_table = load_table
    erb :results, locals: { results_table: results_table }
  end

  get '/company/:company' do
    ip, agent  = ENV['REMOTE_ADDR'], ENV['HTTP_USER_AGENT']
    company_details(params[:company],ip, agent)
  end

  run!
end
