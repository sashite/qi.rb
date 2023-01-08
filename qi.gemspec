# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name                   = "qi"
  spec.version                = ::File.read("VERSION.semver").chomp
  spec.author                 = "Cyril Kato"
  spec.email                  = "contact@cyril.email"
  spec.summary                = "An abstraction that could help to update positions for games like Shogi."
  spec.description            = spec.summary
  spec.homepage               = "https://github.com/sashite/qi.rb"
  spec.license                = "MIT"
  spec.files                  = ::Dir["LICENSE.md", "README.md", "lib/**/*"]
  spec.required_ruby_version  = ">= 3.2.0"

  spec.add_development_dependency "brutal", ">= 1.6.0.beta4"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-gitlab-security"
  spec.add_development_dependency "rubocop-md"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rake"
  spec.add_development_dependency "rubocop-thread_safety"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "yard"

  spec.metadata["rubygems_mfa_required"] = "true"
end
