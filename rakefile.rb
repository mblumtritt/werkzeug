require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.ruby_opts = %w[-w]
  t.verbose = true
  t.test_files = FileList['test/**/*_test.rb']
end

task :default do
  exec 'rake --tasks'
end
