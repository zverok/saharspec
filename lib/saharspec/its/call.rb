module Saharspec
  module ItsCall
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

RSpec.configure do |rspec|
  rspec.extend Saharspec::ItsCall
  rspec.backtrace_exclusion_patterns << %r{/lib/saharspec/its/call}
end

RSpec::SharedContext.send(:include, Saharspec::ItsCall)
