# frozen_string_literal: true

module Saharspec
  module ExampleGroups
    module InstantContext
      def instant_context(description = nil, lets:, **metadata, &block)
        full_description = "with #{lets.map { "#{_1}=#{_2.inspect}" }.join(', ')}"
        full_description = "#{description} (#{full_description})" if description
        absolute_path, line_number = caller_locations.first.then { [_1.absolute_path, _1.lineno] }

        context full_description, **metadata do
          # Tricking RSpec to think this context was defined where `instant_context` was called,
          # so `rspec that_spec.rb:123` knew it is related
          self.metadata.merge!(absolute_file_path: absolute_path, line_number: line_number)

          lets.each do |name, val|
            let(name) { val }
          end
          instance_eval(&block)
        end
      end
    end
  end
end

RSpec.configure do |rspec|
  rspec.extend Saharspec::ExampleGroups::InstantContext
  rspec.backtrace_exclusion_patterns << %r{/lib/saharspec/example_groups/instant_context}
end
