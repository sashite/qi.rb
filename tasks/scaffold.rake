# frozen_string_literal: true

desc "Scaffold"
task :scaffold! do
  print "Generating brutal test suite... "

  `bundle exec brutal`
  `chmod +x test.rb`

  puts "Done."
end
