**saharspec** is a set of additions to RSpec. It's name is a pun on Russian word "сахар"
("sahar", means "sugar") and Sahara desert. So, it is a set of RSpec sugar, to make your
specs dry as Sahara.

## Usage

`gem install saharspec`

Then, probably in your `spec_helper.rb`

```ruby
require 'saharspec'
# or feature-by-feature
require 'saharspec/its_map'
```

## Parts

### `its_map`

Like `rspec/its`, but for processing arrays:

```ruby
subject { html_document.search('ul#menu > li') }

# before
it { expect(subject.map(&:text)).to all not_be_empty }

# after
its_map(:text) { are_expected.to all not_be_empty }
```

### `its_call`

```ruby
subject { some_operation_that_may_fail }

# before
it { expect { subject }.to raise_error(...) }

# after
its_call { is_expected.to raise_error(...) }
```

### `send_message(object, method)` matcher

```ruby
# before
it {
  expect(Net::HTTP).to receive(:get).with('http://google.com').and_return('not this time')
  fetcher
}

# after
it {
  expect { fetcher }.to send_message(Net::HTTP, :get).with('http://google.com').returning('not this time')
}
# after + its_call
subject { fetcher }
its_call { is_expected.to send_message(Net::HTTP, :get).with('http://google.com').returning('not this time') }
```

Note: there is [reasons]() why it is not in rspec-matchers, though, not very persuative for
me.

### `and_not`

```ruby
# before
it {
  expect { kill_alligator }.to change(Alligator, :count).by(1)
}
it {
  expect { kill_alligator }.not_to change(Hyppopotam, :count)
}

# before + official RSpec recomendation to define negated matchers everywhere
RSpec.define_negated_matcher :not_to_change, :change

it {
  expect { kill_alligator }
    .to change(Alligator, :count).by(1)
    .and not_to_change(Hyppopotam, :count)
}

# after
it {
  expect { kill_alligator }
    .to change(Alligator, :count).by(1)
    .and_not change(Hyppopotam, :count)
}

# after: but your first matcher STILL should be positive, or everything is broken
```
