require 'httparty'
class Review

  PARTNER_ID = "106891"
  PARTNER_KEY = "3XZ25H3ujO"
  BASE_URL = "http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=#{PARTNER_ID}&t.k=#{PARTNER_KEY}&action=employers"

  def review(company, ip, agent)
    results(build_url(company, ip, agent))
  end

  private

    def results(url)
      HTTParty.get(url).body
    end

    def build_url(company, ip, agent)
      "#{BASE_URL}&q=#{company}&userip=#{ip}&useragent=#{agent}"
    end
end