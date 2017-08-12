# Saharspec: Specs DRY as Sahara

**saharspec** is a set of additions to RSpec. It's name is a pun on Russian word "сахар"
("sahar", means "sugar") and Sahara desert. So, it is a set of RSpec sugar, to make your
specs dry as a desert.

## Usage

Unreleased at RubyGems yet! But you can try it by adding to your Gemfile

```ruby
gem 'saharspec', git: 'https://github.com/zverok/saharspec.git'
```

Then, probably in your `spec_helper.rb`

```ruby
require 'saharspec'
# or feature-by-feature
require 'saharspec/its/map'
```

## Parts

### `its_map`

Like `rspec/its`, but for processing arrays:

```ruby
subject { html_document.search('ul#menu > li') }

# before
it { expect(subject.map(&:text)).to all not_be_empty }

# after
require 'saharspec/its/map'

its_map(:text) { are_expected.to all not_be_empty }
```

### `its_call`

```ruby
subject { some_operation_that_may_fail }

# before
it { expect { subject }.to raise_error(...) }

# after
require 'saharspec/its/call'

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

### `eq_multiline(text)` matcher

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
require 'saharspec/matchers/eq_multiline
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
