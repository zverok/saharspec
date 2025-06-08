# frozen_string_literal: true

defined?(RSpec) or
  fail 'RSpec is not present in the current environment, check that `rspec` ' \
       'is present in your Gemfile and is in the same group as `saharspec`' \

# Umbrella module for all Saharspec RSpec DRY-ing features.
#
# See {file:README.md} or {Its}, {Matchers}, and {ExampleGroups} separately.
#
module Saharspec
end

require_relative 'saharspec/its'
require_relative 'saharspec/matchers'
require_relative 'saharspec/example_groups'
require_relative 'saharspec/util'
