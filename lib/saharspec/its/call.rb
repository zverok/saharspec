module Saharspec
  module Its
    module Call
      def its_call(*args, &block)
        # rubocop:disable Lint/NestedMethodDefinition
        describe('call') do
          let(:__call_subject) do
            warn 'No need to use its_call without arguments, just it {} will work' if args.empty?
            -> { subject.call(*args) }
          end

          def is_expected
            expect(__call_subject)
          end

          example(nil, &block)
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
