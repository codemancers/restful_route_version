require File.join(File.dirname(__FILE__),"test_helper")

class RestfulRouteVersionDependenciesTest < Test::Unit::TestCase
  context "For RestfulRouteVersionDependencies" do 
    setup do
      ActiveSupport::Dependencies.dynamically_defined_constants << "Foo"
      ActiveSupport::Dependencies.dynamically_defined_constants << "Bar"
    end

    should "only remove constans which were not dynamically defined" do
      
    end
  end
end


