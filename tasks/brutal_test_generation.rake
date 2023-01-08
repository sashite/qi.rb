# frozen_string_literal: true
# shareable_constant_value: none

# warn_indent: true

require "brutal"

desc "Generate Brutal test suite"
task :brutal_test_generation do
  print "Generating Brutal test suite... "

  `bundle exec brutal ./brutal/`

  puts "Done."
end
