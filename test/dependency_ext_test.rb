require_relative "test_helper"

class RestfulRouteVersionDependenciesTest < Test::Unit::TestCase
  context "For RestfulRouteVersionDependencies" do 
    setup do
      ActiveSupport::Dependencies.dynamically_defined_constants << "Foo"
      ActiveSupport::Dependencies.dynamically_defined_constants << "Bar"
      ActiveSupport::Dependencies.dynamically_defined_constants << "C"
    end

    should "only remove constants which were not dynamically defined" do
      with_autoloading_fixtures do
        Object.const_set(:Foo,Class.new)
        Object.const_set(:Bar,Class.new)
        Object.const_get(:A)
        Object.const_get(:B)
        Object.const_get(:C)
        ActiveSupport::Dependencies.clear
        assert !Object.const_defined?(:A)
        assert !Object.const_defined?(:B)
        assert Object.const_defined?(:Foo)
        assert Object.const_defined?(:Bar)
        assert Object.const_defined?(:C)
      end
    end
  end

  def with_loading(*from)
    old_mechanism, ActiveSupport::Dependencies.mechanism = ActiveSupport::Dependencies.mechanism, :load
    this_dir = File.dirname(__FILE__)
    parent_dir = File.dirname(this_dir)
    path_copy = $LOAD_PATH.dup
    $LOAD_PATH.unshift(parent_dir) unless $LOAD_PATH.include?(parent_dir)
    prior_autoload_paths = ActiveSupport::Dependencies.autoload_paths
    ActiveSupport::Dependencies.autoload_paths = from.collect { |f| "#{this_dir}/#{f}" }
    yield
  ensure
    $LOAD_PATH.replace(path_copy)
    ActiveSupport::Dependencies.autoload_paths = prior_autoload_paths
    ActiveSupport::Dependencies.mechanism = old_mechanism
    ActiveSupport::Dependencies.explicitly_unloadable_constants = []
  end

  def with_autoloading_fixtures(&block)
    with_loading 'fixture_files', &block
  end

end


