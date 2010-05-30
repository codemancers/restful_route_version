require "rcov/rcovtask"

Rcov::RcovTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/,features\/}
  t.verbose = true
end

