require "sinatra/base"
require_relative "helpers/scraper"
require_relative "helpers/location"

class Dashboard < Sinatra::Base

  helpers Scraper, Location

  get "/" do
    ip = request.env['REMOTE_ADDR']
    ip = `curl https://api.ipify.org`

    location = get_location(ip)['zip_code']
    erb :index, locals: { location: location }
  end

  get '/search' do
    scrape(params[:query], params[:area])
    redirect("/results")
  end

  get '/results' do
    results_table = load_table
    erb :results, locals: { results_table: results_table }
  end

  get '/company/:company' do
    ip, agent  = ENV['REMOTE_ADDR'], ENV['HTTP_USER_AGENT']
    company = company_details(params[:company],ip, agent)
    erb :show_company, :locals => { company: company }
  end

  run!
end
