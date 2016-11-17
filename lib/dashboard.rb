require "sinatra/base"
require_relative "helpers/scraper"  
require_relative "helpers/location"

class Dashboard < Sinatra::Base

  enable :sessions

  helpers Scraper, Location

  get "/" do

    if session[:location] == nil
      ip = request.env['REMOTE_ADDR']
      ip = `curl https://api.ipify.org`
      session[:location] = get_location(ip)['zip_code']
    end

    erb :index, locals: { location: session[:location] }
  end

  get '/search' do
    scrape(params[:query], params[:area])
    redirect("/results/#{params[:area]}")
  end

  get '/results/:area' do
    results_table = load_table
    erb :results, locals: { results_table: results_table, location: params[:area] }
  end

  get '/company/:company' do
    ip, agent  = ENV['REMOTE_ADDR'], ENV['HTTP_USER_AGENT']
    company = company_details(params[:company],ip, agent)
    erb :show_company, :locals => { company: company }
  end

  run!
end
