class String
  # allows to pretty test agains multiline strings:
  #   %Q{
  #     |test
  #     | me
  #   }.unindent # =>
  # "test
  #  me"
  def unindent
    gsub(/\n\s+?\|/, "\n")    # for all lines looking like "<spaces>|" -- remove this.
    .gsub(/\|\n/, "\n")       # allow to write trailing space not removed by editor
    .gsub(/\A\n|\n\s+\Z/, '') # remove empty strings before and after
  end
end
