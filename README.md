# PRbed

pure ruby implementation of PLINK bed file stream reader

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'PRbed'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install PRbed

## Usage

```ruby
require "PRbed"
r = PRbed::Reader.new("test/test") # bfile prefix
r.each_variants do |variant, fam, genotypes|
  p [variant, fam, genotypes]
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/holrock/PRbed.

