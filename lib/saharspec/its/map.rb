module Saharspec
  module ItsMap
    def its_map(attribute, *options, &block) # rubocop:disable Metrics/AbcSize
      # rubocop:disable Lint/NestedMethodDefinition
      describe("map(&:#{attribute})") do
        let(:__its_map_subject) do
          if Array === attribute
            if subject.all? { |s| Hash === s }
              subject.map { |s|
                attribute.inject(s) { |inner, attr| inner[attr] }
              }
            else
              subject.map { |inner| inner[*attribute] }
            end
          else
            attribute_chain = attribute.to_s.split('.').map(&:to_sym)
            attribute_chain.inject(subject) do |inner_subject, attr|
              inner_subject.map(&attr)
            end
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

RSpec.configure do |rspec|
  rspec.extend Saharspec::ItsMap
  rspec.backtrace_exclusion_patterns << %r(/lib/saharspec/its/map)
end

RSpec::SharedContext.send(:include, Saharspec::ItsMap)
