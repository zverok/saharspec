# frozen_string_literal: true

module Saharspec
  module Its
    module With
      # Creates a nested context + example with `let` values defined from the arguments.
      #
      # @example
      #
      #   subject { x + y }
      #
      #   it_with(x: 1, y: 2) { is_expected.to eq 3 }
      #
      #   # is equivalent to
      #
      #   context "with x=1, y=2" do
      #     let(:x) { 1 }
      #     let(:y) { 2 }
      #
      #     it { is_expected.to eq 3 }
      #   end
      #
      # See also {Its::BlockWith#its_block_with #its_block_with} for a block form, and
      # {ExampleGroups::InstantContext#instant_context #instant_context} for inline `context`+`let` definitions.
      def it_with(**lets, &block)
        context "with #{lets.map { "#{_1}=#{_2.inspect}" }.join(', ')}" do
          lets.each do |name, val|
            let(name) { val }
          end
          example(nil, &block)
        end
      end
    end
  end
end

RSpec.configure do |rspec|
  rspec.extend Saharspec::Its::With
  rspec.backtrace_exclusion_patterns << %r{/lib/saharspec/its/with}
end

RSpec::SharedContext.include Saharspec::Its::With
