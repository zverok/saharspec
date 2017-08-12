require 'saharspec/its/call'

RSpec.describe :its_call do
  let(:relevant) { [] }
  let(:irrelevant) { [] }

  subject { relevant << 'foo' }

  its_call { is_expected.to change { relevant }.to(['foo']) }
  its_call { is_expected.not_to(change { irrelevant }) }

  describe 'metadata passing' do
    before(:each, :some_metadata) { relevant << 'bar' }

    its_call { is_expected.to change { relevant }.to(['foo']) }
    its_call(:some_metadata) { is_expected.to change { relevant }.to(%w[bar foo]) }
  end
end
