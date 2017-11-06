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
