# Fast::Inline

The objective of this gem is inline ruby expressions.

Examples:

## Inline local variable

```ruby
a = 1
b = 2
a + b
```

Will be transformed into:

```ruby
1 + 2
```

## Method definition

```ruby
def one
 1
end
one + 1
```

Will be refactored to:

```ruby
1 + 1
```

### Method definition with arguments

Will be refactored to:

```ruby
def plus_one(arg)
 arg + 1
end
2 + plus_one(3)
```

Will be refactored to:

```ruby
2 + 3 + 4
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fast-inline'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fast-inline

## Usage

For local variable:

```ruby
Fast::Inline.local_variable('a = 1;a + 1') 
# => ';1 + 1'
```

For method definition:

```ruby
Fast::Inline.method_def('def plus_one number; number + 1 end; plus_one(1)')
# => '; 1 + 1'
```

## TODO

- [ ] Preserve variable scope
- [ ] Pipe and combine multiple refactoring strategies
- [ ] Work with class and initiatize methods
- [ ] Work with multiple files
- [ ] Friendly CLI to make it a tool

## Videos

While developing this tool I created a series of videos since the begining.

Here is the [playlist](https://www.youtube.com/playlist?list=PLMi5gHdF3kjSxZ6FrAS81EwWzroxiEwsC) and
the intro is [here](https://www.youtube.com/watch?v=KQXglNLUv7o).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/fast-inline. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Fast::Inline project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/fast-inline/blob/master/CODE_OF_CONDUCT.md).
