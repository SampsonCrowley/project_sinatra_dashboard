require 'rubygems'
require 'mechanize'
require 'chronic'
require 'csv'
require 'date'
require_relative 'agent.rb'
require_relative 'job_builder.rb'
require_relative 'job_saver.rb'

module Scraper

  FILE_PATH = File.expand_path("../../../data/jobs_table.csv", __FILE__)

  def scrape(query, ip, agent)
    dice     = DiceAgent.new
    indeed   = IndeedAgent.new
    dice_b   = DiceBuilder.new
    indeed_b = IndeedBuilder.new
    saver    = JobSaver.new

    dice_jobs = dice_b.build_jobs(dice.search(query))
    indeed_jobs = indeed_b.build_jobs(indeed.search(query))

    
    saver.save(FILE_PATH, dice_jobs)
    saver.save(FILE_PATH, indeed_jobs)
  end

  def load_table
    CSV.table(FILE_PATH, {:headers => true } )
  end
end