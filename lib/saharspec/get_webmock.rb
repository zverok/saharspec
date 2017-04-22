# TODO: PR to webmock itself?..
#
RSpec::Matchers.define :get_webmock do |url|
  match do |block|
    WebMock.reset!
    stub_request(:get, url).tap { |req|
      req.to_return(@response) if @response
    }
    block.call
    expect(WebMock).to have_requested(:get, url)
  end

  chain :and_return do |response|
    @response = case response
    when String
      {body: response}
    when Hash
      response
    else
      fail "Expected string or Hash of params, got #{response.inspect}"
    end
  end

  supports_block_expectations
end
