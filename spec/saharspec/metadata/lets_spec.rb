require 'saharspec/metadata/lets'

RSpec.describe :metadata_lets do
  let(:sum) { 5 + y }

  context 'when lets is set', lets: {foo: 'bar'} do
    it { expect(foo).to eq 'bar' }

    context 'when lets are nesting', lets: {foo: 'baz', baz: 'test'} do
      it { expect(baz).to eq 'test' }
      it { expect(foo).to eq 'baz' }
    end
  end

  context 'when lets is adjusting the other let', lets: {y: 5} do
    it { expect(sum).to eq 10 }
  end

  context '', lets: {x: 100, title: "OK"} do
    it { |ex| expect(ex.full_description).to eq 'metadata_lets x=100 title="OK" ' }
    it { expect(self.class.description).to eq 'x=100 title="OK"' }

    context '', lets: {y: 200} do
      it { |ex| expect(ex.full_description).to eq 'metadata_lets x=100 title="OK" y=200 ' }
      it { expect(self.class.description).to eq 'y=200' }
    end

    context '', lets: {x: 500} do
      it { |ex| expect(ex.full_description).to eq 'metadata_lets x=100 title="OK" x=500 ' }
      it { expect(self.class.description).to eq 'x=500' }
    end
  end

  context 'with ', lets: {x: 100, title: "OK"} do
    it { |ex| expect(ex.full_description).to eq 'metadata_lets with x=100 title="OK" ' }
    it { expect(self.class.description).to eq 'with x=100 title="OK"' }

    context 'when ', lets: {y: 200} do
      it { |ex| expect(ex.full_description).to eq 'metadata_lets with x=100 title="OK" when y=200 ' }
      it { expect(self.class.description).to eq 'when y=200' }
    end
  end
end
