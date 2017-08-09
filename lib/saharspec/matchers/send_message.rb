module Saharspec
  module Matchers
    class SendMessage
      include RSpec::Mocks::ExampleMethods

      def initialize(target, method)
        @target = target
        @method = method
      end

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

      def supports_block_expectations?
        true
      end

      def description
        'to send %p.%s' % [@target, @method]
      end

      def failure_message
        "expected #{description}, but sent nothing"
      end

      def failure_message_when_negated
        "expected not #{description}, but sent it"
      end

      private

      def run(subject)
        fail NoMethodError, "undefined method `#{@method}' for#{@target.inspect}:#{@target.class}" unless @target.respond_to?(@method)
        allow(@target).to allower
        subject.call
      end

      def allower
        receive(@method)
      end

      def expectation
        have_received(@method)
      end
    end
  end
end

module RSpec
  module Matchers
    def send_message(target, method)
      Saharspec::Matchers::SendMessage.new(target, method)
    end
  end
end
