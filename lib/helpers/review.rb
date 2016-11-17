require 'httparty'
require 'pp'

Company = Struct.new(:company_name,
                     :website,
                     :ratings,
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
      ratings = {}
      ratings["Overall Rating"] = results['overallRating']
      ratings["Culture and Values"] = results["cultureAndValuesRating"]
      ratings["Senior Leadership"] = results["seniorLeadershipRating"]
      ratings["Compensation"] = results["compensationAndBenefitsRating"]
      ratings["Opportunities"] = results["careerOpportunitiesRating"]
      ratings["Work life balance"] = results["workLifeBalanceRating"]
      featured_review = {
                          date: results["featuredReview"]["reviewDateTime"],
                          headline: results["featuredReview"]["headline"],
                          pros: results["featuredReview"]["pros"],
                          cons: results["featuredReview"]["cons"]
                        } if results["featuredReview"]
      Company.new(company_name,
                  website,
                  ratings,
                  featured_review)
    end

    def results(url)
      JSON.parse(HTTParty.get(url).body)
    end

    def build_url(company, ip, agent)
      "#{BASE_URL}&q=#{company}&userip=#{ip}&useragent=#{agent}"
    end
end
