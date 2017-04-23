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
    .gsub(/\A\n|\n +\Z/, '')  # remove one empty string before and after, allows prettier %Q{}
  end
end
