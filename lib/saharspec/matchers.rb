# frozen_string_literal: true

module Saharspec
  # All Saharspec matchers, when required, included into `RSpec::Matchers` namespace.
  #
  # See:
  #
  # * {RSpec::Matchers#dont #dont}: `expect { block }.to change(this).and dont.change(that)`
  # * {RSpec::Matchers#send_message #send_message}: `expect { block }.to send_message(File, :write)`
  # * {RSpec::Matchers#ret #ret}: `expect { block }.to ret value`
  # * {RSpec::Matchers#be_json #be_json}: `expect(response.body).to be_json('foo' => 'bar')`
  # * {RSpec::Matchers#eq_multiline #eq_multiline}: multiline equality akin to squiggly heredoc
  #
  module Matchers
  end
end

require_relative 'matchers/eq_multiline'
require_relative 'matchers/send_message'
require_relative 'matchers/ret'
require_relative 'matchers/dont'
require_relative 'matchers/be_json'
