# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name         = 'qi'
  spec.version      = File.read('VERSION.semver').chomp
  spec.author       = 'Cyril Kato'
  spec.email        = 'contact@cyril.email'
  spec.summary      = 'Represent positions and play moves.'
  spec.description  = "Instantiate PCN's positions and apply PMN's moves."
  spec.homepage     = 'https://developer.sashite.com/specs/'
  spec.license      = 'MIT'
  spec.files        = Dir['LICENSE.md', 'README.md', 'lib/**/*']

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/sashite/qi.rb/issues',
    'documentation_uri' => 'https://rubydoc.info/gems/qi/index',
    'source_code_uri' => 'https://github.com/sashite/qi.rb'
  }

  spec.add_development_dependency 'brutal'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-thread_safety'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'yard'
end
