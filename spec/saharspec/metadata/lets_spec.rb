require 'saharspec/metadata/lets'

RSpec.describe :metadata_lets do
  let(:sum) { 5 + y }

  context 'when lets is set', lets: {foo: 'bar'} do
    it { expect(foo).to eq 'bar' }
  end

  context 'when lets is adjusting the other let', lets: {y: 5} do
    it { expect(sum).to eq 10 }
  end

  context '', lets: {x: 100, title: "OK"} do
    it { expect(self.class.description).to eq 'with x=100, title="OK"' }
  end
end
