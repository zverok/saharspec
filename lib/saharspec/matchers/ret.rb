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
    def ret(expected)
      Saharspec::Matchers::Ret.new(expected)
    end
  end
end
