Job = Struct.new(:title, :job_link, :employer, :location, :company_id, :job_id, :posted)

class DiceAgent < Mechanize

  def search(term, location = nil)
    url = "https://www.dice.com/jobs?q="
    query = term.gsub(" ", "+")
    location = "&l=#{location}&radius=30" if location
    page = get(url + query + location)
    job_divs = page.search(".complete-serp-result-div")
  end
end

class IndeedAgent < Mechanize

  def search(term, location = nil)
    url = "http://www.indeed.com/jobs?q="
    query = term.gsub(" ", "+")
    location = "&l=#{location if location}"
    page = get(url + query + location)
    job_divs = page.search(".result")
  end
end


