require 'httparty'
require 'pp'

Company = Struct.new(:company_name,
                     :website,
                     :overall,
                     :culture_and_values,
                     :senior_leadership,
                     :compensation,
                     :opportunities,
                     :work_life_balance,
                     :featured_review
                     )
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
      results = results['response']['employers'][0]
      company_name = results['name']
      website = results['website']
      overall = results['overallRating']
      culture_and_values = results["cultureAndValuesRating"]
      senior_leadership = results["seniorLeadershipRating"]
      compensation = results["compensationAndBenefitsRating"]
      opportunities = results["careerOpportunitiesRating"]
      work_life_balance = results["workLifeBalanceRating"]
      featured_review = {
                          date: results["featured_review"]["reviewDateTime"]
                          headline: results["featured_review"]["headline"],
                          pros: results["featured_review"]["pros"],
                          cons: results["featured_review"]["cons"]
                        }
      Company.new(company_name,
                  website, 
                  overall,
                  culture_and_values,
                  senior_leadership,
                  compensation,
                  opportunities,
                  work_life_balance,
                  featured_review)
    end

    def results(url)
      JSON.parse(HTTParty.get(url).body)
    end

    def build_url(company, ip, agent)
      "#{BASE_URL}&q=#{company}&userip=#{ip}&useragent=#{agent}"
    end
end
