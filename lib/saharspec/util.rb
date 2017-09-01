module Saharspec
  module Util
    def multiline(string)
      # 1. for all lines looking like "<spaces>|" -- remove this.
      # 2. remove trailing spaces
      # 3. preserve trailing spaces ending with "|", but remove the pipe
      # 4. remove one empty line before & after, allows prettier %Q{}
      # TODO: check if all lines start with "|"?
      string
        .gsub(/^ *\|/, '')
        .gsub(/ +$/, '')
        .gsub(/\|$/, '')
        .gsub(/(\A *\n|\n *\z)/, '')
    end
  end
end
