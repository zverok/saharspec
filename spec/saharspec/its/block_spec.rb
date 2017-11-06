require 'saharspec/its/block'

RSpec.describe :its_block do
  let(:relevant) { [] }
  let(:irrelevant) { [] }

  subject { relevant << 'foo' }

  its_block { is_expected.to change { relevant }.to(['foo']) }
  its_block { is_expected.not_to(change { irrelevant }) }

  describe 'metadata passing' do
    before(:each, :some_metadata) { relevant << 'bar' }

    its_block { is_expected.to change { relevant }.to(['foo']) }
    its_block(:some_metadata) { is_expected.to change { relevant }.to(%w[bar foo]) }
  end
end
