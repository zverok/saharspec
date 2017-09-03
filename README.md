# Saharspec: Specs DRY as Sahara

[![Gem Version](https://badge.fury.io/rb/saharspec.svg)](http://badge.fury.io/rb/saharspec)
[![Build Status](https://travis-ci.org/zverok/saharspec.svg?branch=master)](https://travis-ci.org/zverok/saharspec)

**saharspec** is a set of additions to RSpec. It's name is a pun on Russian word "сахар"
("sahar", means "sugar") and Sahara desert. So, it is a set of RSpec sugar, to make your
specs dry as a desert.

## Usage

Install it as a usual gem `saharspec`.

Then, probably in your `spec_helper.rb`

```ruby
require 'saharspec'
# or feature-by-feature
require 'saharspec/its/map'
# or some part of a library
require 'saharspec/its'
```

## Parts

### Matchers

Just a random matchers I've found useful in my studies.

#### `send_message(object, method)` matcher

```ruby
# before
it {
  expect(Net::HTTP).to receive(:get).with('http://google.com').and_return('not this time')
  fetcher
}

# after
require 'saharspec/matchers/send_message'

it {
  expect { fetcher }.to send_message(Net::HTTP, :get).with('http://google.com').returning('not this time')
}
# after + its_call
subject { fetcher }
its_call { is_expected.to send_message(Net::HTTP, :get).with('http://google.com').returning('not this time') }
```

Note: there is [reasons](https://github.com/rspec/rspec-expectations/issues/934) why it is not in rspec-mocks, though, not very persuative for
me.

#### `eq_multiline(text)` matcher

Dedicated to checking some multiline text generators.

```ruby
# before: one option

  it { expect(generated_code).to eq("def method\n  a = @b**2\n  return a + @b\nend") }

# before: another option
  it {
    expect(generated_code).to eq(%{def method
  a = @b**2
  return a + @b
end})
  }

# after
require 'saharspec/matchers/eq_multiline'

  it {
    expect(generated_code).to eq_multiline(%{
      |def method
      |  a = @b**2
      |  return a + @b
      |end
    })
  }
```
(empty lines before/after are removed, text deindented up to `|` sign)

### `dont`: matcher negation

```ruby
# before
RSpec.define_negated_matcher :not_change, :change
it { expect { code }.to do_stuff.and not_change(obj, :attr) }

# after: no `define_negated_matcher` needed
it { expect { code }.to do_stuff.and dont.change(obj, :attr) }
```

### `its`-addons

**Notice**: There are different opinions on usability/reasonability of `its(:attribute)` syntax,
extracted from RSpec core and currently provided by [rspec-its](https://github.com/rspec/rspec-its)
gem. Some find it (and a notion of description-less examples) bad practice. But if you are like me
and love DRY-ness of it, probably you'll love those two ideas, taking `its`-syntax a bit further.

#### `its_map`

Like `rspec/its`, but for processing arrays:

```ruby
subject { html_document.search('ul#menu > li') }

# before
it { expect(subject.map(&:text)).to all not_be_empty }

# after
require 'saharspec/its/map'

its_map(:text) { are_expected.to all not_be_empty }
```

#### `its_call`

```ruby
subject { some_operation_that_may_fail }

# before
it { expect { subject }.to raise_error(...) }

# after
require 'saharspec/its/call'

its_call { is_expected.to raise_error(...) }
```

## State & future

I use all of the components of the library on daily basis. Probably, I will extend it with other
ideas and findings from time to time (next thing that needs gemification is WebMock DRY-er, allowing
code like `expect { code }.to request_webmock(url, params)` instead of preparing stubs and then
checking them). Stay tuned.

## Author

[Victor Shepelev](http://zverok.github.io/)

## License

[MIT](https://github.com/zverok/time_math2/blob/master/LICENSE.txt).
