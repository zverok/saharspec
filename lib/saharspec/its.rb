module Saharspec
  # Wrapper module for all `its_*` RSpec additions.
  #
  # See:
  # * {Map#its_map #its_map}
  # * {Block#its_block #its_block}
  # * {Call#its_call #its_call}
  module Its
  end
end

require_relative 'its/map'
require_relative 'its/block'
require_relative 'its/call'
