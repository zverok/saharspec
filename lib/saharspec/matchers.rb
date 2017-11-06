module Saharspec
  # All Saharspec matchers, when required, included into `RSpec::Matchers` namespace.
  #
  # See:
  #
  # * {RSpec::Matchers#dont #dont}
  # * {RSpec::Matchers#send_message #send_message}
  # * {RSpec::Matchers#eq_multiline #eq_multiline}
  # * {RSpec::Matchers#ret #ret}
  #
  module Matchers
  end
end

require_relative 'matchers/eq_multiline'
require_relative 'matchers/send_message'
require_relative 'matchers/ret'
