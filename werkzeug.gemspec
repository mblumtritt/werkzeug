require File.expand_path('../lib/werkzeug/version', __FILE__)

Gem::Specification.new do |spec|
  all_files = %x(git ls-files).split($/)
  spec.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.0.0'
  spec.name = spec.rubyforge_project = 'werkzeug'
  spec.version = Werkzeug::VERSION
  spec.summary = 'Collection of every day tools for Ruby projects.'
  spec.description = spec.summary
  spec.author = 'Mike Blumtritt'
  spec.email = 'mike.blumtritt@invision.de'
  spec.homepage = 'https://github.com/mblumtritt/werkzeug'
  spec.metadata = {'issue_tracker' => 'https://github.com/mblumtritt/werkzeug/issues'}
  spec.require_paths = %w[lib]
  spec.test_files = all_files.grep(%r{^test/})
  spec.files = all_files - spec.test_files
  spec.has_rdoc = false # not yet
  # spec.extra_rdoc_files = %w[README.md]
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
end
