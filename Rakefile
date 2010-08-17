require "rcov/rcovtask"

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
