module Saharspec
  module Matchers
    # @private
    class Ret
      include RSpec::Matchers::Composable

      def initialize(expected)
        @expected = expected
      end

      def matches?(subject)
        @subject = subject
        return false unless subject.respond_to?(:call)
        @actual = subject.call
        @actual == @expected
      end

      def supports_block_expectations?
        true
      end

      def description
        "to return #{@expected}"
      end

      def failure_message
        "expected #{description}, " +
          (@subject.respond_to?(:call) ? "but returned #{@actual.inspect}" : 'but was not callable')
      end

      def failure_message_when_negated
        "expected not #{description}, but returned it"
      end
    end
  end
end

module RSpec
  module Matchers
    # `ret` (short for `return`) checks if provided block **returns** value specified.
    #
    # It should be considered instead of standard `eq` matcher in the situations:
    #
    # 1. Several block behaviors tested in the same test, joined with `.and`, or in separate tests
    # 2. You test what some block or method returns with arguments, using {Call#its_call #its_call}
    #
    # @example
    #    # case 1: block is a subject
    #    subject { -> { do_something } }
    #
    #    it { is_expected.not_to raise_error }
    #    it { is_expected.to change(some, :value).by(1) }
    #    it { is_expected.to ret 8 }
    #
    #    # or, joined:
    #    specify {
    #      expect { do_something }.to change(some, :value).by(1).and ret(8)
    #    }
    #
    #    # case 2: with arguments
    #    subject { %i[a b c].method(:[]) }
    #
    #    its_call(1) { is_expected.to ret :b }
    #    its_call(1..-1) { is_expected.to ret %i[b c] }
    #    its_call('foo') { is_expected.to raise_error TypeError }
    #
    def ret(expected)
      Saharspec::Matchers::Ret.new(expected)
    end
  end
end
