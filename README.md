# prime

A basic implementation of a prime number generator.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     prime:
       github: wontruefree/prime
   ```

## Usage

```crystal
require "prime"

primes = [] of Int32

Prime.each do |p|
  break if p > 541
  primes << p
end
```

## Contributing

1. Fork it (<https://github.com/your-github-user/prime/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Jack Thorne](https://github.com/wontruefree) - creator and maintainer
