require "rubygems"
gem 'activesupport', '~> 2.3.4'
gem 'actionpack', '~> 2.3.4'
gem 'activerecord', '~> 2.3.4'
gem 'rails', '~> 2.3.4'

require "active_support"
require "action_controller"
require "action_view"
require "action_pack"
require "initializer"

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


module Rails
  def self.root
    File.expand_path(File.join(File.dirname(__FILE__), "rails_sandbox"))
  end

  def self.backtrace_cleaner
    @@backtrace_cleaner ||= begin
      # Relies on ActiveSupport, so we have to lazy load to postpone definition until AS has been loaded
      require 'rails/backtrace_cleaner'
      Rails::BacktraceCleaner.new
    end
  end
end

$:<< File.join(File.dirname(__FILE__), "..", "lib")
$:<< File.join(File.dirname(__FILE__), "rails_sandbox", "app", "controllers")

require "restful_route_version"
ActionController::Base.extend(RestfulRouteVersion::ActionControllerExtension)
