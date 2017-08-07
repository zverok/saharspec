require 'saharspec/matchers/eq_multiline'

RSpec.describe :eq_multiline do
  describe 'simple' do
    specify {
      expect("test\nme\nplease").to eq_multiline(%{
        |test
        |me
        |please
      })
    }
  end

  describe 'before/after empty lines removal' do
    it 'removes one line' do
      expect("test\nme\nplease").to eq_multiline(%{
        |test
        |me
        |please
      })
    end

    it 'does not remove several lines' do
      expect("\ntest\nme\nplease\n").to eq_multiline(%{
        |
        |test
        |me
        |please
        |
      })
    end
  end

  describe 'trailing spaces preservation' do
    it 'removes trailing spaces' do
      expect("test\nme\nplease").to eq_multiline("|test    \n|me  \n|please")
    end

    it 'allows to mark not-to-remove spaces' do
      expect("test\nme  \nplease").to eq_multiline(%{
        |test
        |me  |
        |please
      })
    end
  end

  describe 'broken lines' do
  end
end
