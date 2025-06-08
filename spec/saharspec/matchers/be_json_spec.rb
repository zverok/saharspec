require 'saharspec/matchers/be_json'

RSpec.describe :be_json do
  describe 'argument-less' do
    it { expect('{}').to be_json }
    it { expect('{"foo": "bar"}').to be_json }
    it { expect('definitely not').not_to be_json }
    it {
      expect { expect('definitely not').to be_json }
        .to raise_error(RSpec::Expectations::ExpectationNotMetError, /expected value to be a valid JSON/)
    }
  end

  describe 'with arguments' do
    it { expect('{"foo": "bar"}').to be_json('foo' => 'bar') }
    it { expect('{"foo": "baz"}').not_to be_json('foo' => 'bar') }
    it { expect('{"foo": 1, "bar": 2}').to be_json include('foo' => 1) }
    it { expect('{"foo": 2, "bar": 1}').not_to be_json include('foo' => 1) }
    it {
      expect { expect('{"foo": 2, "bar": 1}').to be_json include('foo' => 1) }
        .to raise_error(RSpec::Expectations::ExpectationNotMetError, /to be a valid JSON matching/)
    }

    it { expect('{"foo": 1, "bar": 2}').to be_json include('foo' => kind_of(Numeric)) }
    it { expect('{"foo": "2", "bar": 1}').not_to be_json include('foo' => kind_of(Numeric)) }

    it { expect('{"foo": "bar"}').to be_json_sym(foo: 'bar') }
    it { expect('{"foo": "baz"}').not_to be_json_sym(foo: 'bar') }
  end
end
