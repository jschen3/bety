require 'spec_helper'
 
describe "Login page", :type => :request do
  describe "GET /login"  do
    it "should return a valid response" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get "/login"
      response.status.should be(200)
    end
  end
end
 
feature 'Login works' do
  context 'GET /login' do
    it 'notify on successful login' do
      visit login_path
      # This will make the page search a bit faster by going to div#content
      within ("#content") do
        fill_in 'Login', with:'carlcrott'
        fill_in 'Password', with: 'asdfasdf'
        click_button 'Log in'
      end
#      print page.body
      page.should have_content("Logged in successfully")

    end
    it 'notify on unsuccessful login' do
      visit login_path
      within ("#content") do
        fill_in 'Login', with:'carlcrott'
        fill_in 'Password', with: 'wrong'
        click_button 'Log in'
      end
      page.should have_content("The login credentials you provided are incorrect")
    
    end
    
  end
end

