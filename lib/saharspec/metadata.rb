# frozen_string_literal: true

module Saharspec
  # Wrapper module for all RSpec additions available via example or context metadata.
  #
  # Note: because including some functionality by context metadata is not obvious,
  # saharspec doesn't require them by default when you `require 'saharspec'` or
  # `require 'saharspec/metadata'`, you need to require specifically the functionality
  # you are planning to use.
  #
  # See:
  #
  # ## {Lets}
  #
  # ```ruby
  # context 'with admin', lets: {role: :admin} do
  #   it { is_expected.to be_allowed }
  # end
  #
  # # this is the same as
  # context 'with admin' do
  #   let(:role) { :admin }
  #
  #   it { is_expected.to be_allowed }
  # end
  # ```
  #
  module Metadata
  end
end

require_relative 'metadata/lets'
