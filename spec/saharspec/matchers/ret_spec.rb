require 'saharspec/matchers/ret'

RSpec.describe :ret do
  context 'subject is a block' do
    subject { -> { 5 } }

    it { is_expected.to ret 5 }
    it { is_expected.not_to ret 3 }

    context 'with argument matchers' do
      it { is_expected.to ret kind_of(Numeric) }
      it { is_expected.to ret have_attributes(to_s: '5') }
    end
  end

  context 'diffability' do
    subject { -> { [{a: 1}, {b: 2}, {c: 3}] } }

    it {
      expect { is_expected.to ret [{a: 1}, {b: 2}, {c: 4}] }
        .to raise_error(RSpec::Expectations::ExpectationNotMetError, /Diff:/)
    }
  end

  describe '#failure_message' do
    before { matcher === -> { 3 } }

    let(:matcher) { ret(internal) }
    subject { matcher.failure_message }

    context 'simple value' do
      let(:internal) { 5 }

      it { is_expected.to eq 'expected to return 5, but returned 3' }
    end

    context 'RSpec matcher' do
      let(:internal) { be_a(String) }
      it { is_expected.to eq 'return value mismatch: expected 3 to be a kind of String' }
    end
  end

  describe '#failure_message_when_negated' do
    before { matcher === -> { 3 } }

    let(:matcher) { ret(internal) }
    subject { matcher.failure_message_when_negated }

    context 'simple value' do
      let(:internal) { 3 }

      it { is_expected.to eq 'expected not to return 3, but returned it' }
    end

    context 'RSpec matcher' do
      let(:internal) { be_a(Integer) }
      it { is_expected.to eq 'return value mismatch: expected 3 not to be a kind of Integer' }
    end
  end

  context 'subject responds to #call' do
    let(:cls) {
      Class.new {
        def call
          5
        end
      }
    }
    subject { cls.new }

    it { is_expected.to ret 5 }
    it { is_expected.not_to ret 3 }
  end

  context 'subject is not callable' do
    specify {
      expect { expect(5).to ret 5 }
        .to raise_error(RSpec::Expectations::ExpectationNotMetError, /not callable/)
    }
  end
end
