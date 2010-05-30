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

    should "provide inherit_routes routing method" do
      assert @mapper.respond_to?(:inherit_routes)
    end

    should "automatically load classes which has to be loaded dynamically" do
      
    end
  end
end
