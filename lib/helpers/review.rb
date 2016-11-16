require 'httparty'
require 'pp'

Company = Struct.new(:company_name, :website, :rating)
class Review

  PARTNER_ID = "106891"
  PARTNER_KEY = "3XZ25H3ujO"
  BASE_URL = "http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=#{PARTNER_ID}&t.k=#{PARTNER_KEY}&action=employers"

  def review(company, ip, agent)
    results = results(build_url(company, ip, agent))
    return false if results['response']['employers'].empty?
    build_company(results)
  end

  private

    def build_company(results)
      pp results
      company_name = results['response']['employers'][0]['name']
      website = results['response']['employers'][0]['website']
      rating = results['response']['employers'][0]['overallRating']
      Company.new(company_name, website, rating)
    end

    def results(url)
      JSON.parse(HTTParty.get(url).body)
    end

    def build_url(company, ip, agent)
      "#{BASE_URL}&q=#{company}&userip=#{ip}&useragent=#{agent}"
    end
end