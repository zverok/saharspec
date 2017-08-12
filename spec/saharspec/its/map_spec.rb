require 'saharspec/its/map'

RSpec.describe :its_map do
  subject do
    %w[test me please]
  end

  its_map(:length) { is_expected.to eq [4, 2, 6] }

  context 'method chain' do
    its_map(:'reverse.upcase') { is_expected.to eq %w[TSET EM ESAELP] }
  end

  describe '[]' do
    context 'class responding to #[]' do
      let(:klass) {
        Class.new do
          def initialize(n)
            @n = n
          end

          def [](a, b)
            (a + b) * @n
          end
        end
      }

      subject { [klass.new(1), klass.new(2), klass.new(3)] }

      its_map([1, 2]) { is_expected.to eq [3, 6, 9] }
    end

    context 'nested hashes' do
      subject { [{a: {b: 1}}, {a: {b: 2}}, {a: {b: 3}}] }

      its_map(%i[a b]) { is_expected.to eq [1, 2, 3] }
    end
  end

  describe 'metadata passing' do
    before(:each, :some_metadata) { subject << 'foo' }

    its_map(:length) { is_expected.to eq [4, 2, 6] }
    its_map(:length, :some_metadata) { is_expected.to eq [4, 2, 6, 3] }
  end
end
