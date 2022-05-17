require 'saharspec/its/call'
require 'saharspec/matchers/ret'

RSpec.describe :its_call do
  context 'simple' do
    let(:array) { [] }
    subject { -> { array << 1 } }

    its_call { is_expected.not_to raise_error }
    its_call { is_expected.to change(array, :size).by(1) }
  end

  context 'with args' do
    let(:array) { [] }
    subject { ->(a) { array << a } }

    its_call(1) { is_expected.not_to raise_error }
    its_call(88) { is_expected.to change { array }.to([88]) }
  end

  context 'when method with keyword args (Ruby 2.7)' do
    def t(**args)
      args
    end

    subject { method(:t) }

    its_call(a: 1, b: 2) { is_expected.to ret(a: 1, b: 2) }
  end
end
