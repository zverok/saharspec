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
    # @note
    #   There is a case when `ret` fails: when it is _not the first_ in a chain of matchers joined
    #   by `.and`. That's not exactly the matchers bug, that's how RSpec works (loses block's return
    #   value passing the block between matchers)
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
    #      expect { do_something }.to ret(8).and change(some, :value).by(1)
    #    }
    #
    #    # case 2: with arguments
    #    subject { %i[a b c].method(:[]) }
    #
    #    its_call(1) { is_expected.to ret :b }
    #    its_call(1..-1) { is_expected.to ret %i[b c] }
    #    its_call('foo') { is_expected.to raise_error TypeError }
    #
    #    # Values are tested with ===, this also works:
    #    its_call(1) { is_expected.to ret instance_of(Symbol) }
    #    its_call(1..-1) { is_expected.to ret instance_of(Array).and have_attributes(length: 2) }
    #
    # @param expected Any object. `ret` matcher compares it with block's return value using `===`, so
    #   it also can be any pattern-alike object, including RSpec matchers.
    def ret(expected)
      Saharspec::Matchers::Ret.new(expected)
    end
  end
end
