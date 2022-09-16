# frozen_string_literal: true

# Umbrella module for all Saharspec RSpec DRY-ing features.
#
# See {file:README.md} or {Its} and {Matchers} separately.
#
module Saharspec
end

require 'rspec/core'
require_relative 'saharspec/its'
require_relative 'saharspec/matchers'
require_relative 'saharspec/util'
