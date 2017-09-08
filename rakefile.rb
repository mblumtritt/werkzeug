require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.ruby_opts = %w[-w]
  t.warning = true
  t.verbose = ARGV.include?('--verbose')
  t.test_files = FileList['test/**/*/*_test.rb']
end

task :default do
  exec 'rake --tasks'
end