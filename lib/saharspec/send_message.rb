RSpec::Matchers.define :send_message do |object, message|
  match do |block|
    allower = receive(message)
              .tap { |m| m.with(*@with) if @with }
              .tap { |m| m.and_return(@return) if @return }
              .tap { |m| m.and_call_original if @call_original }
    allow(object).to allower

    block.call

    matcher = have_received(message).tap { |m| m.with(*@with) if @with }
    expect(object).to matcher
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

  chain :times do |n|
    @times = n
  end

  chain :once do
    times(n)
  end

  supports_block_expectations
end
