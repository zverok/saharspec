# frozen_string_literal: true

module Saharspec
  # Wrapper module for all `its_*` RSpec additions.
  #
  # ## {Map#its_map #its_map}
  #
  # ```ruby
  # subject { %w[1 2 3] }
  # its_map(:to_s) { is_expected.to eq [1, 2, 3] }
  # ```
  #
  # ## {Call#its_call #its_call}
  #
  # ```ruby
  # subject { [1, 2, 3].method(:[]) }
  # its_call(2) { is_expected.to ret 3 }
  # its_call('foo') { is_expected.to raise_error }
  # ```
  #
  # ## {Block#its_block #its_block}
  #
  # ```ruby
  # subject { something_action }
  # its_block { is_expected.not_to raise_error }
  # its_block { is_expected.to change(some, :value).by(1) }
  # ```
  #
  # ## {With#it_with #it_with}
  #
  # ```ruby
  # subject { x + y }
  # it_with(x: 1, y: 2) { is_expected.to eq 3 }
  # ```
  #
  # ## {BlockWith#its_block_with #its_block_with}
  #
  # ```ruby
  # subject { x + y }
  # its_block_with(x: 1, y: nil) { is_expected.to raise_error }
  # ```
  #
  module Its
  end
end

require_relative 'its/map'
require_relative 'its/block'
require_relative 'its/call'
