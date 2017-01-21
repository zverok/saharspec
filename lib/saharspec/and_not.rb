# NB: It is a long-living discussion in RSpec development about this
# or similar feature, see for example https://github.com/rspec/rspec-expectations/issues/493
#
# Being pragmatic, we just want to have ability to use `and_not`.
# This implementation is utterly naive and subject to change,
# but at least it works.
#
module RSpec
  module Matchers
    module BuiltIn
      class Not < BaseMatcher
        def initialize(matcher)
          @matcher = matcher
        end

        def description
          "not #{@matcher.description}"
        end

        def match(_expected, actual)
          !@matcher.matches?(actual)
        end

        def supports_block_expectations?
          @matcher.supports_block_expectations?
        end
      end
    end

    module Composable
      def and_not(matcher)
        BuiltIn::Compound::And.new(self, BuiltIn::Not.new(matcher))
      end
    end
  end
end
