# Saharspec history

## master

* Fix `lets:` to really work :) Including nested contexts redefining `lets:` multiple times.
* Alternative to `lets:` (too magical!), is `instant_context`:
  ```ruby
  instant_context lets: {a: 1} do
    # ...
  end

  # is the same as
  context "with a=1" do
    let(:a) { 1 }
    # ...
  end
  ```
* Add experimental `it_with`/`its_blocks_with` additions:
  ```ruby
  subject { x + y }

  it_with(x: 1, y: 2) { is_expected.to eq 3 }

  # Same as:
  context 'with x=1, y=2' do
    let(:x) { 1 }
    let(:y) { 2 }

    it { is_expected.to eq 3 }
  end
  ```
* TODO: Rubocop cops suggesting the simplifications?
* Add more "copies" of the `expect(...)`/`allow(...)` RSpec DSL to `send_message`: `at_least`/`twice`/`trice`/`yielding`.

## 0.0.10 -- 2023-02-18

* Add `lets:` metadata helper for DRYer defining of simple `let`s in multiple contexts;
* Minimum supported Ruby version is 2.7
* Add a handler for when `saharspec` is called before/without `rspec`, to provide an informative error message ([@Vagab](https://github.com/Vagab))

## 0.0.9 -- 2022-05-17

* Properly lint RSpec specs using `its_block`/`its_call`/`its_map` with `rubocop-rspec` >= 2.0 ([@ka8725](https://github.com/ka8725))
* Fix `its_block` and `its_call` to support RSpec 3.11

## 0.0.8 -- 2020-10-10

* Better `dont` failure message (just use underlying matchers `failure_message_when_negated`)

## 0.0.7 -- 2020-04-11

* Allow `its_call` to work properly with keyword args on Ruby 2.7

## 0.0.6 -- 2019-10-05

* Fix `dont.send_message` combination behavior (and generally, behavior of `dont.` with matchers
  defining custom `does_not_matches?`);
* Better `ret` matcher failure message when there is a complicated matcher on the right side (use
  its `failure_message` instead of `description`);
* Update `send_message` matcher description to be more readable;
* Drop Ruby 2.2 support.

## 0.0.5 -- 2018-03-03

* `be_json` matcher;
* make `ret` diffable.

## 0.0.4 -- 2017-11-07

* Update `its_call` description generation, looks better with `rspec --format doc`

## 0.0.3 -- 2017-11-06

* Introduce new `its`-family addition: `its_call(*args)`
```ruby
let(:array) { %i[a b c] }
subject { array.method(:delete_at) }
its_call(1) { is_expected.to change(array, :length).by(-1) }
```
* Introduce new `ret` matcher ("block is expected to return"), useful in context when block is your
primary subject:

```ruby
let(:array) { %i[a b c] }
subject { array.method(:delete_at) }
its_call(1) { is_expected.to ret(:b).and change(array, :length).by(-1) }
```
* Introduce experimental `dont` matcher combiner (instead of `RSpec.define_negated_matcher`), used
  as `expect { something }.to dont.change { anything }`;
* **Breaking**: rename `its_call`→`its_block` (because the name was needed for other means).

## 0.0.2 -- 2017-09-01

* Make `send_message` composable;
* Add `Util#multiline`.

## 0.0.1 -- 2017-08-14

Initial!
