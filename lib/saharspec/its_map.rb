module RSpec
  module Its
    def its_map(attribute, *options, &block) # rubocop:disable Metrics/AbcSize
      # rubocop:disable Lint/NestedMethodDefinition
      describe("map(&:#{attribute})") do
        let(:__its_map_subject) do
          attribute_chain = attribute.to_s.split('.').map(&:to_sym)
          attribute_chain.inject(subject) do |inner_subject, attr|
            inner_subject.map(&attr)
          end
        end

        def is_expected
          expect(__its_map_subject)
        end

        alias_method :are_expected, :is_expected

        options << {} unless options.last.is_a?(Hash)

        example(nil, *options, &block)
      end
      # rubocop:enable Lint/NestedMethodDefinition
    end
  end
end
