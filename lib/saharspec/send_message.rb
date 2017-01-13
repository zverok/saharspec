RSpec::Matchers.define :send_message do |object, message|
  match do |block|
    allow(object).to receive(message)
      .tap { |m| m.with(*@with) if @with }
      .tap { |m| m.and_return(@return) if @return }
      .tap { |m| m.and_call_original if @call_original }

    block.call

    expect(object).to have_received(message)
      .tap { |m| m.with(*@with) if @with }
  end

  chain :with do |*with|
    @with = with
  end

  chain :returning do |returning|
    @return = returning
  end

  chain :calling_original do
    @call_original = true
  end

  supports_block_expectations
end
