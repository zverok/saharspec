# frozen_string_literal: true

module Saharspec
  # Wrapper module for all RSpec additions that adjust example groups (`context`) creation.
  #
  # ## {InstantContext#instant_context #instant_context}
  #
  # ```ruby
  # subject { x + y }
  #
  # instant_context 'with numeric values', lets: {x: 1, y: 2} do
  #   it { is_expected.to eq 3 }
  # end
  # ```
  #
  module ExampleGroups
  end
end

require_relative 'example_groups/instant_context'
