require_relative '../util'

module Saharspec
  module Matchers
    # @private
    class EqMultiline < RSpec::Matchers::BuiltIn::Eq
      include Util
      def initialize(expected)
        super(multiline(expected))
      end
    end
  end
end

module RSpec
  module Matchers
    # Allows to pretty test multiline strings with complex indentation (for example, results of
    # code generation).
    #
    # In provided string, removes first and last empty line, trailing spaces and leading spaces up
    # to `|` character.
    #
    # If you need to preserve trailing spaces, end them with another `|`.
    #
    # @example
    #     require 'saharspec/matchers/eq_multiline'
    #
    #     expect(some_code_gen).to eq_multiline(%{
    #       |def something
    #       |  a = 5
    #       |  a**2
    #       |end
    #     })
    #
    # @param expected [String]
    def eq_multiline(expected)
      Saharspec::Matchers::EqMultiline.new(expected)
    end
  end
end
