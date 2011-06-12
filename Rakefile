require 'rubygems'
require 'rake'

desc "Run tests"
task :test do
  test_files = Dir["test/*_test.rb"]
  $:.unshift(File.dirname(__FILE__)) unless
    $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
  test_files.each { |x| load(x) }
end


begin
  gem 'jeweler', '~> 1.4'
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    gem.name        = 'restful_route_version'
    gem.summary     = 'Versioning your routes in Rails3'
    gem.description = 'Versioning your routes in Rails3'
    gem.email       = 'gethemant@gmail.com'
    
    gem.homepage    = 'http://github.com/gnufied/%s' % gem.name

    gem.authors     = [ 'Hemant Kumar']

    gem.rubyforge_project = 'restful_route_version'

    gem.add_dependency 'activesupport',   '~> 3.0.0'
    gem.add_dependency 'actionpack',      '~> 3.0.0'
    gem.add_dependency 'railties',        '~> 3.0.0'
  end

  Jeweler::GemcutterTasks.new

  FileList['tasks/**/*.rake'].each { |task| import task }
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end

task(:spec) {} # stub out the spec task for as long as we don't have any specs
