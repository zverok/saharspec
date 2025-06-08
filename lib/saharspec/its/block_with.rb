# frozen_string_literal: true

module Saharspec
  module Its
    module BlockWith
      # Creates a nested context + example with `let` values defined from the arguments, and
      # the subject treated as a block.
      #
      # @example
      #
      #   subject { x + y }
      #
      #   its_block_with(x: 1, y: nil) { is_expected.to raise_error }
      #
      #   # is equivalent to
      #
      #   context "with x=1, y=2" do
      #     let(:x) { 1 }
      #     let(:y) { nil }
      #
      #     it { expect { subject }.to raise_error }
      #   end
      #
      def its_block_with(**lets, &block)
        context "with #{lets.map { "#{_1}=#{_2.inspect}" }.join(', ')} as block" do
          lets.each do |name, val|
            let(name) { val }
          end

          def is_expected # rubocop:disable Lint/NestedMethodDefinition
            expect { subject }
          end

          example(nil, &block)
        end
      end
    end
  end
end

RSpec.configure do |rspec|
  rspec.extend Saharspec::Its::BlockWith
  rspec.backtrace_exclusion_patterns << %r{/lib/saharspec/its/block_with}
end

RSpec::SharedContext.include Saharspec::Its::BlockWith
