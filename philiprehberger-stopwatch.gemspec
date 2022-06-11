# frozen_string_literal: true

require_relative 'lib/philiprehberger/stopwatch/version'

Gem::Specification.new do |spec|
  spec.name          = 'philiprehberger-stopwatch'
  spec.version       = Philiprehberger::Stopwatch::VERSION
  spec.authors       = ['Philip Rehberger']
  spec.email         = ['me@philiprehberger.com']

  spec.summary       = 'Precision stopwatch with lap timing, pause/resume, and formatted output'
  spec.description   = 'High-resolution stopwatch using monotonic clock with start, stop, reset, lap timing, ' \
                       'pause/resume support, and a class-level measure helper for block timing.'
  spec.homepage      = 'https://philiprehberger.com/open-source-packages/ruby/philiprehberger-stopwatch'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri']       = 'https://github.com/philiprehberger/rb-stopwatch'
  spec.metadata['changelog_uri']         = 'https://github.com/philiprehberger/rb-stopwatch/blob/main/CHANGELOG.md'
  spec.metadata['bug_tracker_uri']       = 'https://github.com/philiprehberger/rb-stopwatch/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['lib/**/*.rb', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']
end
