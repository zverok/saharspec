# frozen_string_literal: true

module Saharspec
  module Its
    module BlockWith
      def its_block_with(**lets, &block)
        context "with #{lets.map { "#{_1}=#{_2.inspect}" }.join(', ')} as block" do
          lets.each do |name, val|
            let(name) { val }
          end

          def is_expected
            expect { subject }
          end

          example(nil, &block)
        end
      end
    end
  end
end

RSpec.configure do |rspec|
  rspec.extend Saharspec::Its::BlockWith
  rspec.backtrace_exclusion_patterns << %r{/lib/saharspec/its/block_with}
end

RSpec::SharedContext.include Saharspec::Its::BlockWith
