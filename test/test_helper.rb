require "rubygems"
gem 'activesupport', '~> 2.3.4'
gem 'actionpack', '~> 2.3.4'
gem 'activerecord', '~> 2.3.4'
gem 'rails', '~> 2.3.4'

require "active_support"
require "action_controller"
require "action_view"
require "action_pack"

require "shoulda"

$:<< File.join(File.dirname(__FILE__),"..","lib")

require "restful_route_version"
