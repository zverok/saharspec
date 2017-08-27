module Saharspec
  module Matchers
    # @private
    class SendMessage
      include RSpec::Mocks::ExampleMethods
      include RSpec::Matchers::Composable

      def initialize(target, method)
        @target = target
        @method = method
      end

      # DSL
      def with(*arguments)
        @arguments = arguments
        self
      end

      def returning(res)
        @res = res
        self
      end

      def calling_original
        @call_original = true
        self
      end

      def exactly(n)
        @times = n
        self
      end

      def times
        raise NoMethodError unless @times
        self
      end

      def once
        exactly(1)
      end

      def twice
        exactly(2)
      end

      # Matching
      def matches?(subject)
        run(subject)
        expect(@target).to expectation
        true
      end

      def does_not_match?(subject)
        run(subject)
        expect(@target).not_to expectation
        true
      end

      # Static properties
      def supports_block_expectations?
        true
      end

      def description
        format('to send %p.%s', @target, @method)
      end

      def failure_message
        "expected #{description}, but sent nothing"
      end

      def failure_message_when_negated
        "expected not #{description}, but sent it"
      end

      private

      def run(subject)
        @target.respond_to?(@method) or
          raise NoMethodError,
                "undefined method `#{@method}' for#{@target.inspect}:#{@target.class}"
        allow(@target).to allower
        subject.call
      end

      def allower
        receive(@method).tap do |a|
          a.and_return(@res) if @res
          a.and_call_original if @call_original
        end
      end

      def expectation
        have_received(@method).tap do |e|
          e.with(*@arguments) if @arguments
          e.exactly(@times).times if @times
        end
      end
    end
  end
end

module RSpec
  module Matchers
    # Checks if the (block) subject sends specified message to specified object.
    #
    # @example
    #   # before:
    #   specify {
    #      allow(double).to receive(:fetch)
    #      code_being_tested
    #      expect(double).to have_received(:fetch).with(something)
    #   }
    #
    #   # after:
    #   require 'saharspec/matchers/send_message'
    #   it { expect { code_being_tested }.to send_message(double, :fetch).with(something) }
    #   # after + its_call
    #   require 'saharspec/its/call'
    #   subject { code_being_tested }
    #   its_call { is_expected.to send_message(double, :fetch).with(something) }
    #
    #
    # @param target Object which expects message, double or real object
    # @param method [Symbol] Message being expected
    #
    # @return Instance of a matcher, allowing the following additional methods:
    #
    #   * `once`, `twice`, `exactly(n).times`;
    #   * `with(arguments)`;
    #   * `calling_original`;
    #   * `returning(response)`.
    #
    def send_message(target, method)
      Saharspec::Matchers::SendMessage.new(target, method)
    end
  end
end
