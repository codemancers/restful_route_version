require File.join(File.dirname(__FILE__),"test_helper")

class RestfulRouteVersionRouteSetTest < Test::Unit::TestCase
  context "Versioned routing extension" do
    setup do
      @route_set = ActionController::Routing::RouteSet.new()
      @mapper = ActionController::Routing::RouteSet::Mapper.new(@route_set)
    end
    
    should "provide version_namespace routing method" do
      assert @mapper.respond_to?(:version_namespace)
    end

    should "capture specified namespace when using version_namespace" do
      route_block = lambda do |map|
        map.version_namespace("foo") do |foo_route|
          foo_route.resources :articles
        end
      end
      route_block.call(@mapper)
      assert !ActiveSupport::Dependencies.dynamically_defined_constants.blank?
    end

    should "capture route block if cache_route is true when using version_namespace" do
      route_block = lambda do |map|
        map.version_namespace("foo", :cache_route => true) do |foo_route|
          foo_route.resources :articles
        end
      end
      route_block.call(@mapper)
      assert !@mapper.cached_namespace_blocks["foo"].blank?
    end

    should "provide inherit_routes routing method" do
      assert @mapper.respond_to?(:inherit_routes)
    end

    

    should "automatically load classes which has to be loaded dynamically" do
      
    end
  end

  context "Restful route extension with inherit_routes" do 
    setup do
      @route_set = ActionController::Routing::RouteSet.new()
      @mapper = ActionController::Routing::RouteSet::Mapper.new(@route_set)
      @route_block = lambda do |map|
        map.version_namespace :api do |api_routes|
          api_routes.version_namespace(:v10,:cache_route => true) do |v10_routes|
            v10_routes.resources :articles
            v10_routes.resources :comments
            v10_routes.resources :notes
          end
          
          api_routes.version_namespace(:v11, :cache_route => true) do |v11_routes|
            v11_routes.inherit_routes("api/v10", :except => %w(articles))
            v11_routes.resources :tags
            v11_routes.resources :articles, :collection => {:search => :get }
          end

          api_routes.version_namespace(:v12) do |v12_routes|
            v12_routes.inherit_routes("api/v11")
            v12_routes.resources :lessons
          end
          
        end #end of map.version_namespace(:api)
      end #end of route_block
      
    end #end of setup block
    
    should "create derived routes when using inherit_routes" do
      @route_block.call(@mapper)
      v12_tag_route = @route_set.named_routes.routes[:edit_api_v12_tag]
      assert !v12_tag_route.blank?
      assert_match /\/api\/v12\/tags\/\:id\/edit/, v12_tag_route.to_s
    end
  end
end
