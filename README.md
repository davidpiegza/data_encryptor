# DataEncryptor

DataEncryptor is a simple wrapper for OpenSSL::Cipher to encrypt and decrypt objects. It uses `JSON` to serialize objects
which limits encryption for basic objects. This gem uses the stdlib only.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'data_encryptor'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install data_encryptor

## Usage

You need to specify a key first. In Rails a key can be generated with `rake secret` and set in an initializer file, e.g. `data_encryptor.rb`:

```ruby
DataEncryptor.setup! key: '[key]'
```

The default algorithm is `AES-256-CBC`, this can be changed with:

```ruby
DataEncryptor.setup! key: '[key]', algorithm: 'AES-128-CBC'
```

To encrypt data:

```ruby
encrypted_data = DataEncryptor.encrypt('secret credit card information')
```

To decrypt data:

```ruby
DataEncryptor.decrypt(encrypted_data)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davidpiegza/data_encryptor.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
