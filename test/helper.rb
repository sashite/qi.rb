# frozen_string_literal: true

require "simplecov"

# Helper function to run a test and report errors
def Test(name)
  print "  #{name}... "
  yield
  puts "✓"
rescue StandardError => e
  warn "✗ Failure: #{e.message}"
  warn "    #{e.backtrace.first}"
  exit(1)
end
