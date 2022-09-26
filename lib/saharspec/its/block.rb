# frozen_string_literal: true

module Saharspec
  module Its
    module Block
      # Creates nested example that redefines implicit `is_expected` to use subject as a block.
      #
      # @example
      #
      #    subject { calc_something(params) }
      #
      #    # without its_block
      #    context 'with this params' do
      #      it { expect { subject }.to change(some, :value).by(1) }
      #    end
      #
      #    context 'with that params' do
      #      it { expect { subject }.to raise_error(SomeError) }
      #    end
      #
      #    # with its_block
      #    context 'with this params' do
      #      its_block { is_expected.to change(some, :value).by(1) }
      #    end
      #
      #    context 'with that params' do
      #      its_block { is_expected.to raise_error(SomeError) }
      #    end
      #
      # @param options Options (metadata) that can be passed to usual RSpec example.
      # @param block [Proc] The test itself. Inside it, `is_expected` is a synonom
      #   for `expect { subject }`.
      #
      def its_block(*options, &block)
        # rubocop:disable Lint/NestedMethodDefinition
        describe('as block') do
          # FIXME: Not necessary? (Previously, wrapped the subject in lambda, now just repeats it)
          let(:__call_subject) do
            subject
          end

          def is_expected
            expect { __call_subject }
          end

          example(nil, *options, &block)
        end
        # rubocop:enable Lint/NestedMethodDefinition
      end
    end
  end
end

unless defined?(RSpec)
  raise 'RSpec is not present in the current environment, check that `rspec` ' \
        'is present in your Gemfile and is in the same group as `saharspec`' \
end

RSpec.configure do |rspec|
  rspec.extend Saharspec::Its::Block
  rspec.backtrace_exclusion_patterns << %r{/lib/saharspec/its/block}
end

RSpec::SharedContext.include Saharspec::Its::Block
