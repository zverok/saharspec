# Saharspec history

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
