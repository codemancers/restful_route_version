require File.join(File.dirname(__FILE__), "test_helper")
require File.join(File.dirname(__FILE__), "rails_sandbox/app/controllers/api/v10/songs_controller")

module Api
  module V10; end
  module V11; end
end

class Api::V10::SongsControllerTest < ActionController::TestCase
  tests Api::V10::SongsController
  context "For finding template path of controllers which implement their own views" do
    setup do
      ActionController::Routing::Routes.draw do |map|
        map.version_namespace :api do |api_routes|
          api_routes.version_namespace(:v10, :cache_route => true) do |v10_routes|
            v10_routes.resources :articles
            v10_routes.resources :notes
            v10_routes.resources :questions
            v10_routes.resources :songs
          end

          api_routes.version_namespace(:v11, :cache_route => true) do |v11_routes|
            v11_routes.inherit_routes("api/v10", :except => %w(articles questions))
            v11_routes.resources :tags
            v11_routes.resources :articles, :collection => {:search => :get}
          end

          api_routes.version_namespace(:v12) do |v12_routes|
            v12_routes.inherit_routes("api/v11")
            v12_routes.resources :lessons
          end
          map.connect ':controller/:action/:id'
        end #end of map.version_namespace(:api)
      end
      ActionController::Base.prepend_view_path("#{Rails.root}/app/views")
    end #end of setup block

    context "find templates correctly" do
      setup do
        @controller.logger = MockLogger.new
        get :index
      end
      should "run correctly" do
        assert_response :success
        assert_match /Hello from v10 of Music\#index/,@response.body
      end
    end #end of context find_templates_correctly
  end
end


class Api::V11::SongsControllerTest < ActionController::TestCase
  context "For finding template path of derived controllers" do
    setup do
      ActionController::Routing::Routes.draw do |map|
        map.version_namespace :api do |api_routes|
          api_routes.version_namespace(:v10, :cache_route => true) do |v10_routes|
            v10_routes.resources :articles
            v10_routes.resources :notes
            v10_routes.resources :questions
            v10_routes.resources :songs, :collection => { :foo => :get, :bar => :get, :baz => :get }
          end

          api_routes.version_namespace(:v11, :cache_route => true) do |v11_routes|
            v11_routes.inherit_routes("api/v10", :except => %w(articles questions))
            v11_routes.resources :tags
            v11_routes.resources :articles, :collection => {:search => :get}
          end

          api_routes.version_namespace(:v12) do |v12_routes|
            v12_routes.inherit_routes("api/v11")
            v12_routes.resources :lessons
          end
          map.connect ':controller/:action/:id'
        end #end of map.version_namespace(:api)
      end
      ActionController::Base.prepend_view_path("#{Rails.root}/app/views")
      self.class.tests Api::V11::SongsController
    end #end of setup block

    context "find templates correctly from index action of base class" do
      setup do
        @controller.logger = MockLogger.new
        get :index
      end
      should "find and render template" do
        assert_response :success
        assert_match /Hello from v10 of Music#index/,@response.body
      end
    end #end of context find_templates_correctly

    context "find templates correctly directly if available" do
      setup do
        @controller.logger = MockLogger.new
        get :show, :id => 10
      end
      should "find and render template" do
        assert_response :success
        assert_match /Calling Songs#show from v11/, @response.body
      end
    end

    context "find partials correctly for derived controllers" do  
      setup do
        @controller.logger = MockLogger.new()
        get :foo
      end
      should "find and render template" do
        assert_response :success
        assert_match /Calling foo from bar/i, @response.body
      end
    end

    context "raise error when unable to find partials in derived controllers" do
      should "fail to find and render template" do
        assert_raises(ActionView::TemplateError) do
          get :bar
        end
      end
    end

    context "find partials correctly for direct controllers" do
      setup do
        @controller.logger = MockLogger.new()
        get :baz
      end
      should "find and render template" do
        assert_response :success
        assert_match /Hello from baz/i, @response.body
      end
    end

  end
end