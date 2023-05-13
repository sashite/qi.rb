# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name                   = "qi"
  spec.version                = ::File.read("VERSION.semver").chomp
  spec.author                 = "Cyril Kato"
  spec.email                  = "contact@cyril.email"
  spec.summary                = "Versatile Board Game Position Representation"
  spec.description            = "A flexible and customizable library for representing and manipulating game states, ideal for developing board games like chess, shogi, or xiangqi."
  spec.homepage               = "https://github.com/sashite/qi.rb"
  spec.license                = "MIT"
  spec.files                  = ::Dir["LICENSE.md", "README.md", "lib/**/*"]
  spec.required_ruby_version  = ">= 3.2.0"

  spec.metadata["rubygems_mfa_required"] = "true"

  spec.add_runtime_dependency "kernel-boolean"
end
