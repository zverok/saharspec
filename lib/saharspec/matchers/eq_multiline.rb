# allows to pretty test agains multiline strings:
#   %Q{
#     |test
#     | me
#   }.unindent # =>
# "test
#  me"
module Saharspec
  module Matchers
    class EqMultiline < RSpec::Matchers::BuiltIn::Eq
      def initialize(expected)
        # TODO: check if all lines start with "|"?
        super(
          expected
            .gsub(/^ *\|/, '')            # for all lines looking like "<spaces>|" -- remove this.
            .gsub(/ +$/, '')              # remove trailing spaces
            .gsub(/\|$/, '')              # allows to explicitly preserve trailing spaces
            .gsub(/(\A *\n|\n *\z)/, '')  # remove one empty line before/after, allows prettier %Q{}
        )
      end
    end
  end
end

# @private
module RSpec
  module Matchers
    def eq_multiline(expected)
      Saharspec::Matchers::EqMultiline.new(expected)
    end
  end
end
