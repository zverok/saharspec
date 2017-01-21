module RSpec
  module Its
    def its_call(*options, &block)
      # rubocop:disable Lint/NestedMethodDefinition
      describe("call") do
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
