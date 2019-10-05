# frozen_string_literal: true

module Saharspec
  module Its
    module Map
      # Creates nested example which has current subject mapped
      # by specified attribute as its subject.
      #
      # @example
      #
      #   # with attribute
      #   subject { %w[test me please] }
      #   its_map(:length) { is_expected.to eq [4, 2, 6] }
      #
      #   # with attribute chain
      #   its_map('reverse.upcase') { is_expected.to eq %w[TSET EM ESAELP] }
      #
      #   # with Hash (or any other object responding to `#[]`)
      #   subject {
      #     [
      #       {title: 'Slaughterhouse Five', author: {first: 'Kurt', last: 'Vonnegut'}},
      #       {title: 'Hitchhickers Guide To The Galaxy', author: {first: 'Duglas', last: 'Adams'}}
      #     ]
      #   }
      #   its_map([:title]) { are_expected.to eq ['Slaughterhouse Five', 'Hitchhickers Guide To The Galaxy'] }
      #   # multiple attributes for nested hashes
      #   its_map([:author, :last]) { are_expected.to eq ['Vonnegut', 'Adams'] }
      #
      # @param attribute [String, Symbol, Array<String, Symbol>] Attribute name (String or Symbol), attribute chain
      #   (string separated with dots) or arguments to `#[]` method (Array)
      # @param options Other options that can be passed to usual RSpec example.
      # @param block [Proc] The test itself. Inside it, `is_expected` (or `are_expected`) is related to result
      #  of `map`ping the subject.
      #
      def its_map(attribute, *options, &block) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        # rubocop:disable Lint/NestedMethodDefinition
        # TODO: better desciption for different cases
        describe("map(&:#{attribute})") do
          let(:__its_map_subject) do
            if Array === attribute
              if subject.all? { |s| Hash === s }
                subject.map do |s|
                  attribute.inject(s) { |inner, attr| inner[attr] }
                end
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
end

RSpec.configure do |rspec|
  rspec.extend Saharspec::Its::Map
  rspec.backtrace_exclusion_patterns << %r{/lib/saharspec/its/map}
end

RSpec::SharedContext.include Saharspec::Its::Map
