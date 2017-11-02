require 'saharspec/matchers/ret'

RSpec.describe :ret do
  context 'subject is a block' do
    subject { -> { 5 } }

    it { is_expected.to ret 5 }
    it { is_expected.not_to ret 3 }
  end

  context 'subject responds to #call' do
  end

  context 'subject is not callable' do
    specify {
      expect { expect(5).to ret 5 }
        .to raise_error(RSpec::Expectations::ExpectationNotMetError, /not callable/)
    }
  end
end
