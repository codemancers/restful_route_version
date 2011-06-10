require "rubygems"
gem 'activesupport', '~> 3.0.7'
gem 'actionpack', '~> 3.0.7'
gem 'activerecord', '~> 3.0.7'
gem 'rails', '~> 3.0.7'

require "active_support"
require "active_support/dependencies"
require "active_support/core_ext/hash/slice"
require "action_controller"
require "action_view"
require "action_pack"

require "shoulda"

class MockLogger
  attr_reader :logged

  def initialize
    @logged = []
  end

  def method_missing(method, *args)
    @logged << args.first
  end
end

class MockBacktraceCleaner < ActiveSupport::BacktraceCleaner
end

$:<< File.join(File.dirname(__FILE__), "..", "lib")
$:<< File.join(File.dirname(__FILE__), "rails_sandbox", "app", "controllers")

require "restful_route_version"

module Rails
  def self.root
    File.expand_path(File.join(File.dirname(__FILE__), "rails_sandbox"))
  end

  def self.backtrace_cleaner
    @@backtrace_cleaner ||= MockBacktraceCleaner.new()
  end
end

puts "Loading file... #{Rails.root}"



ActionDispatch::Routing::Mapper.send(:include, RestfulRouteVersion::VersionMapper)
ActiveSupport::Dependencies.send(:include, RestfulRouteVersion::DependencyExt)
ActiveSupport::Dependencies.extend(RestfulRouteVersion::DependencyExt)

