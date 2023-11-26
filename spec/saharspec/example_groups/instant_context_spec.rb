require 'saharspec/example_groups/instant_context'

RSpec.describe :instant_context do
  let(:sum) { 5 + y }

  instant_context lets: {foo: 'bar'} do
    it { expect(foo).to eq 'bar' }

    instant_context 'when lets are nesting', lets: {foo: 'baz', baz: 'test'} do
      it { expect(baz).to eq 'test' }
      it { expect(foo).to eq 'baz' }
    end
  end

  instant_context 'when lets is adjusting the other let', lets: {y: 5} do
    it { expect(sum).to eq 10 }
  end

  describe 'titles' do
    instant_context lets: {x: 100, title: "OK"} do
      it { |ex| expect(ex.full_description).to eq 'instant_context titles with x=100, title="OK" ' }
      it { expect(self.class.description).to eq 'with x=100, title="OK"' }

      instant_context lets: {y: 200} do
        it { |ex| expect(ex.full_description).to eq 'instant_context titles with x=100, title="OK" with y=200 ' }
        it { expect(self.class.description).to eq 'with y=200' }
      end

      instant_context 'has a description', lets: {y: 200} do
        it { |ex| expect(ex.full_description).to eq 'instant_context titles with x=100, title="OK" has a description (with y=200) ' }
        it { expect(self.class.description).to eq 'has a description (with y=200)' }
      end

      instant_context lets: {x: 500} do
        it { |ex| expect(ex.full_description).to eq 'instant_context titles with x=100, title="OK" with x=500 ' }
        it { expect(self.class.description).to eq 'with x=500' }
      end
    end
  end

  describe 'metadata' do
    instant_context lets: {a: 1}, freeze: true do
      it { |ex| expect(ex.metadata).to include(freeze: true) }
    end
  end
end
