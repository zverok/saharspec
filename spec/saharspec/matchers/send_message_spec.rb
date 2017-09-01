require 'saharspec/matchers/send_message'

RSpec.describe :send_message do
  let(:obj) {
    Object.new.tap { |o|
      def o.meth
        10
      end
    }
  }

  context 'simple' do
    it { expect { obj.meth }.to send_message(obj, :meth) }
    it { expect {}.not_to send_message(obj, :meth) }
    it { expect { expect {}.to send_message(obj, :meth1) }.to raise_error(NoMethodError) }
  end

  context 'arguments' do
    it { expect { obj.meth(1, 2, 3) }.to send_message(obj, :meth).with(1, 2, 3) }
    it { expect { obj.meth(1, 3, 2) }.not_to send_message(obj, :meth).with(1, 2, 3) }
    it { expect { obj.meth([1, 3, 2]) }.to send_message(obj, :meth).with(array_including(2, 3)) }
    it {
      expect { obj.meth([1, 3, 2]) }.not_to send_message(obj, :meth).with(array_including(3, 4))
    }

    xit 'checks count'
  end

  context 'return value' do
    specify {
      res = nil
      expect { res = obj.meth }.to send_message(obj, :meth).returning(5)
      expect(res).to eq 5
    }
  end

  context 'calling original' do
    specify {
      res = nil
      expect { res = obj.meth }.to send_message(obj, :meth).calling_original
      expect(res).to eq 10
    }
  end

  context 'number of times' do
    it { expect { obj.meth; obj.meth }.to send_message(obj, :meth).exactly(2).times }
    it {
      expect {
        expect { obj.meth; obj.meth }.to send_message(obj, :meth).exactly(3).times
      }.to raise_error(RSpec::Mocks::MockExpectationError) # exactly can't be tested with not_to
    }
  end

  context 'private methods' do
    let(:klass) {
      Object.new.tap { |o|
        def o.meth
          10
        end

        o.send(:private, :meth)
      }
    }
    it { expect { obj.__send__(:meth) }.to send_message(obj, :meth) }
  end

  context 'ordered'
  context 'composability' do
    let(:obj1) {
      Object.new.tap { |o|
        def o.meth
          10
        end
      }
    }
    let(:obj2) {
      Object.new.tap { |o|
        def o.meth
          10
        end
      }
    }

    it {
      expect { obj1.meth; obj2.meth }
        .to send_message(obj1, :meth)
        .and send_message(obj2, :meth)
    }
  end
end
