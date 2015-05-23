Translator
-------

It is an utility through which you can synchronize your locales with [Localapp](https://www.localeapp.com).

Installation
-------

Add this line to your application's Gemfile:

```ruby
gem 'translator_with_localeapp', '~> 1.0.1'
```

And then execute:

```shell
$ bundle install
```

Or install it yourself as:

```shell
$ gem install translator_with_localeapp
```


Usage
-------
With _Redis_:

```ruby
require 'redis'
require 'translator'


Translator.setup do |config|
  # ==> Storage Configurations
  # config.storage = :Redis
  # config.storage_options = { host: 'localhost', port: 6379, db: 1 }

  # ==> Output Configuration
  # By default there is no logging, you can set it to any output
  # stream which respond to `puts`.
  # config.output_stream = nil

  # ==> Localeapp Configuration
  config.localeapp_api_key = ENV['LOCALEAPP_API_KEY']
  # It is the directory where localeapp will sync all the locales files.
  config.data_directory = Rails.root.join('config', 'locales')
end

file_paths = <paths of yml files>
Translator.load!(file_paths)

```

## Storage

Uses [moneta](https://github.com/minad/moneta) gem to wrap various Key/Value stores
Docs for moneta can be found [here](http://www.rubydoc.info/gems/moneta/frames)

Parameters:
- `name` (Symbol) — Name of adapter (See [Moneta::Adapters](http://www.rubydoc.info/gems/moneta/Moneta/Adapters))
- `options` (Hash) (defaults to: {})

Options Hash (options):
- `:expires` (Boolean/Integer) — Ensure that store supports expiration by inserting Expires if the underlying adapter doesn't support it natively and set default expiration time
- `:threadsafe` (Boolean) — default: false — Ensure that the store is thread safe by inserting Moneta::Lock
- `:logger` (Boolean/Hash) — default: false — Add logger to proxy stack (Hash is passed to logger as options)
- `:compress` (Boolean/Symbol) — default: false — If true, compress value with zlib, or specify custom compress, e.g. :quicklz
- `:serializer` (Symbol) — default: :marshal — Serializer used for key and value, disable with nil
- `:key_serializer` (Symbol) — default: options[:serializer] — Serializer used for key, disable with nil
- `:value_serializer` (Symbol) — default: options[:serializer] — Serializer used for value, disable with nil
- `:prefix` (String) — Key prefix used for namespacing (default none)

### Redis

See [redis-db](https://github.com/redis/redis-rb) for options

#### Install Redis

`brew install redis`(Mac)

OR

`sudo apt-get install redis`(Ubuntu)

#### Start Redis

`redis-server`

Testing
-------

Ensure Redis server is installed and started.

```shell
$ bundle install
$ bundle exec rspec spec
```


Contributing
-------

```
1. Fork it ( https://github.com/kuldeepaggarwal/translator/fork ).
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Add test cases and verify all tests are green.
4. Commit your changes (`git commit -am 'Add some feature'`).
5. Push to the branch (`git push origin my-new-feature`).
6. Create new Pull Request.
```
