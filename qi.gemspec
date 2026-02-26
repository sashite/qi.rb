# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name                   = "qi"
  spec.version                = ::File.read("VERSION.semver").chomp
  spec.author                 = "Cyril Kato"
  spec.email                  = "contact@cyril.email"
  spec.summary                = "A minimal, format-agnostic position model for two-player board games."
  spec.description            = "A minimal, format-agnostic library for representing positions " \
                                "in two-player, turn-based board games (chess, shogi, xiangqi, and variants)."
  spec.homepage               = "https://github.com/sashite/qi.rb"
  spec.license                = "Apache-2.0"
  spec.files                  = ::Dir["LICENSE.md", "README.md", "lib/**/*"]
  spec.required_ruby_version  = ">= 3.2.0"

  spec.metadata["rubygems_mfa_required"] = "true"
end
