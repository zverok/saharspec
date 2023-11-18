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
      def self.define(ctx)
        lets = ctx.metadata[:lets]
                  .tap { _1.is_a?(Hash) or fail ArgumentError, "lets: is expected to be a Hash, got #{_1.class}" }

        lets.each { |name, val| ctx.let(name) { val } }

        return unless ctx.metadata[:description].to_s.then { _1.empty? || _1.end_with?(' ') }

        # NB: when two `lets` without names are nested, we have a duplication problem:
        #
        #   context '', {x: 1, y: 2} do
        #     context '', {x: 4}
        #       # here description would be "x=1, y=2 x=4" (two x-s)
        #
        # But redefining same let in nestings is not the best/most popular practice anyway :shrug:
        text = lets.map { "#{_1}=#{_2.inspect}" }.join(' ')
        ctx.metadata[:description] += text
        ctx.metadata[:full_description] += text
      end

      module Configurer
        def configure_group(group)
          super
          Saharspec::Metadata::Lets.define(group) if group.metadata[:lets]
        end
      end
    end
  end
end

RSpec.configure do |config|
  # This is dirty, but this is the only way to make nested `lets:` work. Approaches like
  #   config.include SomeModule, :lets
  # or
  #   config.before(:context, :lets) { do something }
  # only invoke for outer matching group, ignoring the inner.
  class << config
    prepend Saharspec::Metadata::Lets::Configurer
  end
end
