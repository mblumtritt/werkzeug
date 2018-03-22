# frozen_string_literal: true

require File.expand_path('../lib/werkzeug/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name = 'werkzeug'
  spec.version = Werkzeug::VERSION
  spec.summary = 'Collection of every day tools for your Ruby projects.'
  spec.description = <<~EOS
    To reduce overhead and to avoid to re-invent often used patterns and helper classes this gem offers a toolset
    of optimized classes and helper methods. All parts are implemented with focus on fast code avoiding any overhead.
  EOS
  spec.author = 'Mike Blumtritt'
  spec.email = 'mike.blumtritt@invision.de'
  spec.homepage = 'https://github.com/mblumtritt/werkzeug'
  spec.metadata = {'issue_tracker' => 'https://github.com/mblumtritt/werkzeug/issues'}
  spec.rubyforge_project = spec.name

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'

  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.5.0'
  spec.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')

  spec.require_paths = %w[lib]

  all_files = %x(git ls-files -z).split(0.chr)
  spec.test_files = all_files.grep(%r{^test/})
  spec.files = all_files - spec.test_files

  spec.has_rdoc = false # sorry...
  spec.extra_rdoc_files = %w[README.md]
end
