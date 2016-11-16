require 'rubygems'
require 'mechanize'
require 'chronic'
require 'csv'
require 'date'
require_relative 'agent'
require_relative 'job_builder'
require_relative 'job_saver'
require_relative 'review'

module Scraper

  FILE_PATH = File.expand_path("../../../data/jobs_table.csv", __FILE__)



  def scrape(query, location = nil)
    dice     = DiceAgent.new
    indeed   = IndeedAgent.new
    dice_b   = DiceBuilder.new
    indeed_b = IndeedBuilder.new
    saver    = JobSaver.new
    

    dice_jobs = dice_b.build_jobs(dice.search(query, location))
    indeed_jobs = indeed_b.build_jobs(indeed.search(query, location))
    jobs = [dice_jobs, indeed_jobs].flatten

    saver.save(FILE_PATH, jobs)
  end

  def load_table
    CSV.table(FILE_PATH, { headers: true } )
  end

  def company_details(company, ip, agent)
    Review.new.review(company, ip, agent)
  end
end