# frozen_string_literal: true

module Saharspec
  module Its
    module With
      def it_with(**lets, &block)
        context "with #{lets.map { "#{_1}=#{_2.inspect}" }.join(', ')}" do
          lets.each do |name, val|
            let(name) { val }
          end
          example(nil, &block)
        end
      end
    end
  end
end

RSpec.configure do |rspec|
  rspec.extend Saharspec::Its::With
  rspec.backtrace_exclusion_patterns << %r{/lib/saharspec/its/with}
end

RSpec::SharedContext.include Saharspec::Its::With
