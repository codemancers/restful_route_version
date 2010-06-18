require File.join(File.dirname(__FILE__),"test_helper")
require File.join(File.dirname(__FILE__),"rails_sandbox/app/controllers/api/v10/songs_controller")

class RestfulRouteVersionControllerPathTest < ActionController::TestCase
  tests Api::V10::SongsController
  context "For finding template path of controllers which implement their own views" do
    should "match controller path for template path" do
      @controller.logger = MockLogger.new
      get :index
      puts @response.body
    end
  end
end
