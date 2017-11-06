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
        @expected === @actual # rubocop:disable Style/CaseEquality
      end

      def supports_block_expectations?
        true
      end

      def description
        "return #{@expected.respond_to?(:description) ? @expected.description : @expected.inspect}"
      end

      def failure_message
        "expected to #{description}, " +
          (@subject.respond_to?(:call) ? "but returned #{@actual.inspect}" : 'but was not callable')
      end

      def failure_message_when_negated
        "expected not to #{description}, but returned it"
      end
    end
  end
end

module RSpec
  module Matchers
    # `ret` (short for `return`) checks if provided block **returns** value specified.
    #
    # It should be considered instead of simple value matchers (like `eq`) in the situations:
    #
    # 1. Several block behaviors tested in the same test, joined with `.and`, or in separate tests
    # 2. You test what some block or method returns with arguments, using {Call#its_call #its_call}
    #
    # Values are tested with `===`, which allows chaining other matchers and patterns to the check.
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
    #    # Note, that values are tested with ===, which means all other matchers could be chained:
    #    its_call(1) { is_expected.to ret instance_of(Symbol) }
    #    its_call(1..-1) { is_expected.to ret instance_of(Array).and have_attributes(length: 2) }
    #
    def ret(expected)
      Saharspec::Matchers::Ret.new(expected)
    end
  end
end
