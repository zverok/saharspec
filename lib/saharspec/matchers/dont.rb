# frozen_string_literal: true

module Saharspec
  module Matchers
    # @private
    class Not < RSpec::Matchers::BuiltIn::BaseMatcher
      def initialize(*)
        super
        @delegator = Delegator.new
      end

      def description
        "not #{@matcher.description}"
      end

      def match(_expected, actual)
        @matcher or fail ArgumentError, '`dont` matcher used without any matcher to negate. ' \
                                        'Usage: dont.other_matcher(args)'

        # https://www.rubydoc.info/github/rspec/rspec-expectations/RSpec%2FMatchers%2FMatcherProtocol:does_not_match%3F
        # In a negative expectation such as `expect(x).not_to foo`, RSpec will call
        # `foo.does_not_match?(x)` if this method is defined. If it's not defined it
        # will fall back to using `!foo.matches?(x)`.
        if @matcher.respond_to?(:does_not_match?)
          @matcher.does_not_match?(actual)
        else
          !@matcher.matches?(actual)
        end
      end

      def failure_message
        @matcher.failure_message_when_negated
      end

      def supports_block_expectations?
        @matcher.supports_block_expectations?
      end

      def method_missing(m, *a, &)
        if @matcher
          @matcher.send(m, *a, &)
        else
          @matcher = @delegator.send(m, *a, &)
        end

        self
      end

      def respond_to_missing?(method, include_private = false)
        if @matcher
          @matcher.respond_to?(method, include_private)
        else
          @delegator.respond_to_missing?(method, include_private)
        end
      end

      # ActiveSupport 7.1+ defines Object#with, and thus it doesn't go to `method_missing`.
      # So, matchers like `dont.send_message(...).with(...)` stop working correctly.
      #
      # This is dirty, but I don't see another way.
      if Object.instance_methods.include?(:with)
        def with(...)
          @matcher.with(...)
        end
      end

      class Delegator
        include RSpec::Matchers
      end
    end
  end
end

module RSpec
  module Matchers
    # Negates attached matcher, allowing creating negated matchers on the fly.
    #
    # While not being 100% grammatically correct, seems to be readable enough.
    #
    # @example
    #   # before
    #   RSpec.define_negated_matcher :not_change, :change
    #   it { expect { code }.to do_stuff.and not_change(obj, :attr) }
    #
    #   # after: no `define_negated_matcher` needed
    #   it { expect { code }.to do_stuff.and dont.change(obj, :attr) }
    #
    def dont
      Saharspec::Matchers::Not.new
    end
  end
end
