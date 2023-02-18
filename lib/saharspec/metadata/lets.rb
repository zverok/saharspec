# frozen_string_literal: true

module Saharspec
  module Metadata
    # Is included in `context`s and `describe`s that have `lets: Hash` defined, as a shortcut to
    # define simple `let`s in a simple one-line way:
    #
    # ```ruby
    # let(:user) { create(:user, role: role) }
    #
    # # before: a lot of code to say simple things:
    # context 'when admin' do
    #   let(:role) { :admin }
    #
    #   it { is_expected.to be_allowed }
    # end
    #
    # context 'when user' do
    #   let(:role) { :user }
    #
    #   it { is_expected.to be_denied }
    # end
    #
    # # after
    # context 'when admin', lets: {role: :admin} do
    #   it { is_expected.to be_allowed }
    # end
    #
    # context 'when user', lets: {role: :user} do
    #   it { is_expected.to be_denied }
    # end
    #
    # # you can also give empty descriptions, then they would be auto-generated
    #
    # # generates a context with description "with role=:admin"
    # context '', lets: {role: :admin} do
    #   it { is_expected.to be_allowed }
    # end
    # ```
    #
    module Lets
      def self.included(ctx)
        lets = ctx.metadata[:lets]
                  .tap { _1.is_a?(Hash) or fail ArgumentError, "lets: is expected to be a Hash, got #{_1.class}" }

        lets.each { |name, val| ctx.let(name) { val } }
        ctx.metadata[:description].to_s.empty? and
          ctx.metadata[:description] = lets.map { "#{_1}=#{_2.inspect}" }.join(', ').prepend('with ')
      end
    end
  end
end

RSpec.configure do |config|
  config.include Saharspec::Metadata::Lets, :lets
end
