module Saharspec
  # All Saharspec matchers, when required, included into `RSpec::Matchers` namespace.
  #
  # See {RSpec::Matchers#send_message #send_message} and {RSpec::Matchers#eq_multiline #eq_multiline}.
  #
  module Matchers
  end
end

require_relative 'matchers/eq_multiline'
require_relative 'matchers/send_message'
