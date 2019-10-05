# frozen_string_literal: true

require 'json'

module Saharspec
  module Matchers
    # @private
    class BeJson
      include RSpec::Matchers::Composable
      include RSpec::Matchers # to have #match

      ANY = Object.new.freeze

      attr_reader :actual, :expected

      def initialize(expected, **parse_opts)
        @expected_matcher = @expected = expected

        # wrap to make be_json('foo' => matcher) work, too
        unless expected == ANY || expected.respond_to?(:matches?)
          @expected_matcher = match(expected)
        end
        @parse_opts = parse_opts
      end

      def matches?(json)
        @actual = JSON.parse(json, **@parse_opts)
        @expected_matcher == ANY || @expected_matcher === @actual
      rescue JSON::ParserError => e
        @parser_error = e
        false
      end

      def does_not_match?(*args)
        !matches?(*args)
      end

      def diffable?
        true
      end

      def description
        if @expected == ANY
          'be a valid JSON string'
        else
          expected = @expected.respond_to?(:description) ? @expected.description : @expected
          "be a valid JSON matching (#{expected})"
        end
      end

      def failure_message
        failed =
          case
          when @parser_error
            "failed: #{@parser_error}"
          when @expected != ANY
            "was #{@actual}"
          end
        "expected value to #{description} but #{failed}"
      end

      def failure_message_when_negated
        'expected value not to be parsed as JSON, but succeeded'
      end
    end
  end
end

module RSpec
  module Matchers
    # `be_json` checks if provided value is JSON, and optionally checks it contents.
    #
    # If you need to check against some hashes, it is more convenient to use `be_json_sym`, which
    # parses JSON with `symbolize_names: true`.
    #
    # @example
    #
    #   expect('{}').to be_json # ok
    #   expect('garbage').to be_json
    #   # expected value to be a valid JSON string but failed: 765: unexpected token at 'garbage'
    #
    #   expect('{"foo": "bar"}').to be_json('foo' => 'bar') # ok
    #   expect('{"foo": "bar"}').to be_json_sym(foo: 'bar') # more convenient
    #
    #   expect('{"foo": [1, 2, 3]').to be_json_sym(foo: array_including(3)) # nested matchers work
    #   expect(something_large).to be_json_sym(include(meta: include(next_page: Integer)))
    #
    # @param expected Value or matcher to check JSON against. It should implement `#===` method,
    #   so all standard and custom RSpec matchers work.
    def be_json(expected = Saharspec::Matchers::BeJson::ANY)
      Saharspec::Matchers::BeJson.new(expected)
    end

    # `be_json_sym` checks if value is a valid JSON and parses it with `symbolize_names: true`. This
    # way, it is convenient to check hashes content with Ruby's short symbolic keys syntax.
    #
    # See {#be_json_sym} for examples.
    #
    # @param expected Value or matcher to check JSON against. It should implement `#===` method,
    #   so all standard and custom RSpec matchers work.
    def be_json_sym(expected = Saharspec::Matchers::BeJson::ANY)
      Saharspec::Matchers::BeJson.new(expected, symbolize_names: true)
    end
  end
end
