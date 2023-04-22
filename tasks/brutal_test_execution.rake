# frozen_string_literal: true
# shareable_constant_value: none

# warn_indent: true

desc "Brutal test execution"
task :brutal_test_execution do
  puts "Executing Brutal test suite... "

  test_filename_pattern = "#{::Brutal::Format::Ruby::Filename::PREFIX}*#{::Brutal::Format::Ruby::Filename::SUFFIX}"
  fullpath_test_filename_pattern = ::File.join("brutal", "**", test_filename_pattern)

  ::Rake::FileList[fullpath_test_filename_pattern].each do |path|
    print "  - ruby #{path}... "
    `ruby #{path}`
    puts "OK"
  end

  puts "Done."
end
