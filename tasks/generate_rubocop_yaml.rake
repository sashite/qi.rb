# frozen_string_literal: true
# shareable_constant_value: none

# warn_indent: true

require "erb"

desc "Generate RuboCop manifest"
task :generate_rubocop_yaml do
  print "Generating .rubocop.yml file... "

  template = File.read(".rubocop.yml.erb")
  renderer = ERB.new(template)

  file = File.open(".rubocop.yml", "w")
  file.write(renderer.result)
  file.close

  puts "Done."
end
