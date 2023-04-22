# Qi

[![Build Status](https://travis-ci.org/cyril/qi.rb.svg?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/cyril/qi.rb/badges/gpa.svg)][codeclimate]
[![Gem Version](https://badge.fury.io/rb/qi.svg)][gem]
[![Inline docs](http://inch-ci.org/github/cyril/qi.rb.svg?branch=master)][inchpages]
[![Documentation](http://img.shields.io/:yard-docs-38c800.svg)][rubydoc]

> An ordered store of stuff to manage, for Ruby.

## Rubies

* [MRI](https://www.ruby-lang.org/)
* [Rubinius](http://rubini.us/)
* [JRuby](http://jruby.org/)

## Installation

Add this line to your application's Gemfile:

    gem 'qi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qi

## Example

```ruby
require 'qi'

db = Qi::Store.new(8)       # => #<Qi::Store:0x007fb79f09b8d0 @size=8, @captured=nil, @position={}>

result = db.call(2, 3, 'p') # => #<Qi::Store:0x007fb79f091150 @size=8, @captured=nil, @position={3=>"p"}>
result.to_a                 # => [nil, nil, nil, "p", nil, nil, nil, nil]
result.captured             # => nil
```

## Versioning

__Qi__ follows [Semantic Versioning 2.0](http://semver.org/).

## Contributing

1. [Fork it](https://github.com/cyril/qi.rb/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

See `LICENSE.md` file.

[gem]: https://rubygems.org/gems/qi
[travis]: https://travis-ci.org/cyril/qi.rb
[codeclimate]: https://codeclimate.com/github/cyril/qi.rb
[inchpages]: http://inch-ci.org/github/cyril/qi.rb
[rubydoc]: http://rubydoc.info/gems/qi/frames
