require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require "rcov"
require "rcov/rcovtask"
require 'fileutils'

def __DIR__
  File.dirname(__FILE__)
end

Rcov::RcovTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/,features\/}
  t.verbose = true
end

desc "Run tests"
task :test do
  test_files = Dir["test/*_test.rb"]
  $:.unshift(File.dirname(__FILE__)) unless
    $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
  test_files.each { |x| load(x) }
end

include FileUtils
NAME = "restful_route_version"

$LOAD_PATH.unshift __DIR__+'/lib'
require 'restful_route_version'

CLEAN.include ['**/.*.sw?', '*.gem', '.config','*.rbc']
Dir["tasks/**/*.rake"].each { |rake| load rake }


@windows = (PLATFORM =~ /win32/)

SUDO = @windows ? "" : (ENV["SUDO_COMMAND"] || "sudo")

desc "Packages up Restful_route_version."
task :default => [:package]

task :doc => [:rdoc]

spec = Gem::Specification.new do |s|
  s.name = NAME
  s.version = RestfulRouteVersion::VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "MIT-LICENSE", 'TODO']

  s.summary = "Restful_route_version, A Pure Ruby library for Event Driven Network Programming."
  s.description = s.summary
  s.author = "Hemant Kumar"
  s.email = 'gethemant@gmail.com'
  s.homepage = 'http://github.com/gnufied/restful_route_version'
  s.required_ruby_version = '>= 1.8.7'
  s.files = %w(MIT-LICENSE README Rakefile TODO) + Dir.glob("{test,lib,examples}/**/*")
  s.require_path = "lib"
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
end

task :install do
  sh %{rake package}
  sh %{#{SUDO} gem install pkg/#{NAME}-#{RestfulRouteVersion::VERSION} --no-rdoc --no-ri}
end

task :uninstall => [:clean] do
  sh %{#{SUDO} gem uninstall #{NAME}}
end

