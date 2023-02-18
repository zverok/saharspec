# Saharspec: Specs DRY as Sahara

[![Gem Version](https://badge.fury.io/rb/saharspec.svg)](http://badge.fury.io/rb/saharspec)
[![Build Status](https://travis-ci.org/zverok/saharspec.svg?branch=master)](https://travis-ci.org/zverok/saharspec)

**saharspec** is a set of additions to RSpec. It's name is a pun on Russian word "сахар"
("sahar", means "sugar") and Sahara desert. So, it is a set of RSpec sugar, to make your
specs dry as a desert.

## Usage

Install it as a usual gem `saharspec` with `gem install` or `gem "saharspec"` in `:test` group of
your `Gemfile`.

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
# after + its_block
subject { fetcher }
its_block { is_expected.to send_message(Net::HTTP, :get).with('http://google.com').returning('not this time') }
```

Note: there is [reasons](https://github.com/rspec/rspec-expectations/issues/934) why it is not in rspec-mocks, though, not very persuative for
me.

#### `expect { block }.to ret(value)` matcher

Checks whether `#call`-able subject (block, method, command object), when called, return value matching
to expected.

Useful when this callable subject is your primary one:

```ruby
# before: option 1. subject is value
subject { 2 + x }

context 'when numeric' do
  let(:x) { 3 }
  it { is_expected.to eq 5 } # DRY
end

context 'when incompatible' do
  let(:x) { '3' }
  it { expect { subject }.to raise_error } # not DRY
end

# option 2. subject is block
subject { -> { 2 + x } }

context 'when numeric' do
  let(:x) { 3 }
  it { expect(subject.call).to eq 5 } # not DRY
end

context 'when incompatible' do
  let(:x) { '3' }
  it { is_expected.to raise_error } # DRY
end

# after
require 'saharspec/matchers/ret'

subject { -> { 2 + x } }

context 'when numeric' do
  let(:x) { 3 }
  it { is_expected.to ret 5 } # DRY: notice `ret`
end

context 'when incompatible' do
  let(:x) { '3' }
  it { is_expected.to raise_error } # DRY
end
```

Plays really well with `its_call` shown below.

#### `be_json(value)` and `be_json_sym(value)` matchers

Simple matcher to check if string is valid JSON and optionally if it matches to expected values:

```ruby
expect('{}').to be_json # ok
expect('garbage').to be_json
# expected value to be a valid JSON string but failed: 765: unexpected token at 'garbage'

expect('{"foo": "bar"}').to be_json('foo' => 'bar') # ok

# be_json_sym is more convenient to check with hash keys, parses JSON to symbols
expect('{"foo": "bar"}').to be_json_sym(foo: 'bar')

# nested matchers work, too
expect('{"foo": [1, 2, 3]').to be_json_sym(foo: array_including(3))

# We need to go deeper!
expect(something_large).to be_json_sym(include(meta: include(next_page: Integer)))
```

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

Allows to get rid of gazilliions of `define_negated_matcher`. `dont` is not 100% grammatically
correct, yet short and readable enought. It just negates attached matcher.

```ruby
# before
RSpec.define_negated_matcher :not_change, :change

it { expect { code }.to do_stuff.and not_change(obj, :attr) }

# after: no `define_negated_matcher` needed
require 'saharspec/matchers/dont'

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

#### `its_block`

Allows to DRY-ly refer to "block that calculates subject".

```ruby
subject { some_operation_that_may_fail }

# before
context 'success' do
  it { is_expected.to eq 123 }
end

context 'fail' do
  it { expect { subject }.to raise_error(...) }
end

# after
require 'saharspec/its/block'

its_block { is_expected.to raise_error(...) }
```

#### `its_call`

Allows to DRY-ly test callable object with different arguments. Plays well with forementioned `ret`
matcher.

Before:

```ruby
# before
describe '#delete_at' do
  let(:array) { %i[a b c] }

  it { expect(array.delete_at(1) }.to eq :b }
  it { expect(array.delete_at(8) }.to eq nil }
  it { expect { array.delete_at(1) }.to change(array, :length).by(-1) }
  it { expect { array.delete_at(:b) }.to raise_error TypeError }
end

# after
require 'saharspec/its/call'

describe '#delete_at' do
  let(:array) { %i[a b c] }

  subject { array.method(:delete_at) }

  its_call(1) { is_expected.to ret :b }
  its_call(1) { is_expected.to change(array, :length).by(-1) }
  its_call(8) { is_expected.to ret nil }
  its_call(:b) { is_expected.to raise_error TypeError }
end
```

### Metadata handlers

(Experimental.) Those aren't required by default, or by `require 'saharspec/metadata'`, you need to require each by its own. This is done to lessen the confusion if metadata processing isn't expected.

#### `lets:`

A shortcut for defining simple `let`s in the description

```ruby
let(:user) { create(:user, role: role) }

# before: a lot of code to say simple things:

context 'when admin' do
 let(:role) { :admin }

 it { is_expected.to be_allowed }
end

context 'when user' do
 let(:role) { :user }

 it { is_expected.to be_denied }
end

# after

context 'when admin', lets: {role: :admin} do
 it { is_expected.to be_allowed }
end

context 'when user', lets: {role: :user} do
 it { is_expected.to be_denied }
end

# you can also give empty descriptions, then they would be auto-generated

# generates a context with description "with role=:admin"
context '', lets: {role: :admin} do
 it { is_expected.to be_allowed }
end
```

### Linting with RuboCop RSpec

`rubocop-rspec` fails to properly detect RSpec constructs that Saharspec defines (`its_call`, `its_block`, `its_map`).
Make sure to use `rubocop-rspec` 2.0 or newer and add the following to your `.rubocop.yml`:

```yaml
inherit_gem:
  saharspec: config/rubocop-rspec.yml
```

## State & future

I use all of the components of the library on daily basis. Probably, I will extend it with other
ideas and findings from time to time (next thing that needs gemification is WebMock DRY-er, allowing
code like `expect { code }.to request_webmock(url, params)` instead of preparing stubs and then
checking them). Stay tuned.

## Author

[Victor Shepelev](http://zverok.github.io/)

## License

[MIT](https://github.com/zverok/saharspec/blob/master/LICENSE.txt).
