# frozen_string_literal: true

require 'rspec/core'

# Umbrella module for all Saharspec RSpec DRY-ing features.
#
# See {file:README.md} or {Its}, {Matchers}, and {Metadata} separately.
#
module Saharspec
end

require_relative 'saharspec/its'
require_relative 'saharspec/matchers'
require_relative 'saharspec/util'
