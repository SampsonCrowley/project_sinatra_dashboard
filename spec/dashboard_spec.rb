require 'dashboard'

describe Dashboard do 
  
  describe "get /" do 
    it "renders the landing page" do 
      get('/')
      expect(last_response).to be_ok
      expect(last_response.body).to include("<h1>Job Hunt Dashboard</h1>")
    end
  end
end