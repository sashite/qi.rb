# frozen_string_literal: true

SimpleCov.start do
  add_filter "/test/"
  enable_coverage :branch

  minimum_coverage 90
  minimum_coverage_by_file 80

  add_group "Library", "lib"
end
