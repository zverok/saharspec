require 'saharspec/its/with'

RSpec.describe :it_with do
  subject { x + y }

  it_with(x: 1, y: 5) { is_expected.to eq 6 }
end
