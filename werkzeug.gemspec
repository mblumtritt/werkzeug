# frozen_string_literal: true

require_relative 'lib/werkzeug/version'

Gem::Specification.new do |spec|
  spec.name = 'werkzeug'
  spec.version = Werkzeug::VERSION
  spec.author = 'Mike Blumtritt'

  spec.required_ruby_version = '>= 2.7.0'

  spec.summary = 'Collection of every day tools for your Ruby projects.'
  spec.description = <<~DESCRIPTION
    A toolset of optimized classes and helper methods.
    It implements often used patterns and helpers.
    All parts are implemented with focus on fast code avoiding any overhead.
  DESCRIPTION
  spec.homepage = 'https://github.com/mblumtritt/werkzeug'

  spec.metadata['source_code_uri'] = 'https://github.com/mblumtritt/werkzeug'
  spec.metadata['bug_tracker_uri'] =
    'https://github.com/mblumtritt/werkzeug/issues'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'rake'

  all_files = Dir.chdir(__dir__) { `git ls-files -z`.split(0.chr) }
  spec.test_files = all_files.grep(%r{^test/})
  spec.files = all_files - spec.test_files

  spec.extra_rdoc_files = %w[README.md]
end
