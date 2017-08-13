module Saharspec
  module Its
    module Call
      # Creates nested example which converts current subject to a block-subject.
      #
      # @example
      #
      #    subject { calc_something(params) }
      #
      #    # without its_call
      #    context 'with this params'
      #      it { expect { subject }.to change(some, :value).by(1) }
      #    end
      #
      #    context 'with that params'
      #      it { expect { subject }.to raise_error(SomeError) }
      #    end
      #
      #    # with its_call
      #    context 'with this params'
      #      its_call { is_expected.to change(some, :value).by(1) }
      #    end
      #
      #    context 'with that params'
      #      its_call { is_expected.to raise_error(SomeError) }
      #    end
      #
      # @param options Other options that can be passed to usual RSpec example.
      # @param block [Proc] The test itself. Inside it, `is_expected` (or `are_expected`) is analog of
      #   `expect { subject }`.
      #
      def its_call(*options, &block)
        # rubocop:disable Lint/NestedMethodDefinition
        describe('call') do
          let(:__call_subject) do
            -> { subject }
          end

          def is_expected
            expect(__call_subject)
          end

          example(nil, *options, &block)
        end
        # rubocop:enable Lint/NestedMethodDefinition
      end
    end
  end
end

RSpec.configure do |rspec|
  rspec.extend Saharspec::Its::Call
  rspec.backtrace_exclusion_patterns << %r{/lib/saharspec/its/call}
end

RSpec::SharedContext.send(:include, Saharspec::Its::Call)
