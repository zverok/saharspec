require 'saharspec/matchers/send_message'

RSpec.describe :send_message do
  context 'simple' do
    let(:obj) { Object.new.tap { |o| def o.meth; end } }

    context 'message is sent' do
      it { expect { obj.meth }.to send_message(obj, :meth) }
    end

    context 'message is not sent' do
      it { expect {  }.not_to send_message(obj, :meth) }
    end
    context 'object do not have method' do
      it { expect { expect {}.to send_message(obj, :meth1) }.to raise_error(NoMethodError) }
    end
  end

  context 'arguments'
  context 'return value'
  context 'calling original'
  context 'number of times'
  context 'composability'
end
