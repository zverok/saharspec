# TODO: PR to webmock itself?..
#
# RSpec::Matchers.define :request_webmock do |url, method: :get|
#   match do |block|
#     WebMock.reset!
#     stub_request(method, url)
#       .tap { |req| req.with(@with_options) if @with_options && !@with_block }
#       .tap { |req| req.with(@with_options, &@with_block) if @with_block }
#       .tap { |req| req.to_return(@response) if @response }
#     block.call
#     matcher = have_requested(method, url)
#       .tap { |matcher| matcher.with(@with_options) if @with_options && !@with_block }
#       .tap { |matcher| matcher.with(@with_options, &@with_block) if @with_block }
#     expect(WebMock).to matcher
#   end
#
#   chain :with do |options = {}, &block|
#     @with_options = options
#     @with_block = block
#   end
#
#   chain :once do
#     times(1)
#   end
#
#   chain :twice do
#     times(2)
#   end
#
#   chain :times do |n|
#     @times = n
#   end
#
#   chain :at_least_once do
#     at_least_times(1)
#   end
#
#   chain :at_least_twice do
#     at_least_times(2)
#   end
#
#   chain :at_least_times do |n|
#     @at_least_times = n
#   end
#
#   chain :returning do |response|
#     @response =
#       case response
#       when String
#         {body: response}
#       when Hash
#         response
#       else
#         fail "Expected string or Hash of params, got #{response.inspect}"
#       end
#   end
#
#   supports_block_expectations
# end
#
