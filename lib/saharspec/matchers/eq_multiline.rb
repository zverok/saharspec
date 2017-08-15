module Saharspec
  module Matchers
    # @private
    class EqMultiline < RSpec::Matchers::BuiltIn::Eq
      def initialize(expected)
        # 1. for all lines looking like "<spaces>|" -- remove this.
        # 2. remove trailing spaces
        # 3. preserve trailing spaces ending with "|", but remove the pipe
        # 4. remove one empty line before & after, allows prettier %Q{}
        # TODO: check if all lines start with "|"?
        super(
          expected
            .gsub(/^ *\|/, '')
            .gsub(/ +$/, '')
            .gsub(/\|$/, '')
            .gsub(/(\A *\n|\n *\z)/, '')
        )
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
    # @param [String]
    def eq_multiline(expected)
      Saharspec::Matchers::EqMultiline.new(expected)
    end
  end
end
