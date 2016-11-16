require 'httparty'

module Location
  

  def get_location(ip)
    HTTParty.get("http://freegeoip.net/json/#{ip}")
  end

end