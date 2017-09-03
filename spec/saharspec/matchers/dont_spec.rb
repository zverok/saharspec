require 'saharspec/matchers/dont'

RSpec.describe :dont do
  context 'simple' do
    it { expect(2).to dont.eq(1) }
    it { expect(1).not_to dont.eq(1) }
  end

  context 'with block' do
    let(:ary) { [] }
    it { expect {}.to dont.change(ary, :length) }
    it { expect { ary << 1 }.not_to dont.change(ary, :length).by(1) }
  end

  context 'composability' do
    it { expect(2).to dont.eq(1).and eq(2) }
  end

  context 'matcher-less' do
    it {
      expect {
        expect(2).to dont
      }.to raise_error(ArgumentError)
    }
  end
end
