require "./impls/eratosthenes_sieve"
require "./impls/trial_division"
require "./generators/pseudo_prime"
require "./generators/eratosthenes"
require "./generators/trial_division"
require "./generators/twenty_three"

#
# The set of all prime numbers.
#
# == Example
#
#   Prime.each(100) do |prime|
#     p prime  #=> 2, 3, 5, 7, 11, ...., 97
#   end
#
# Prime is Enumerable:
#
#   Prime.first 5 # => [2, 3, 5, 7, 11]
#
# == Retrieving the instance
#
# For convenience, each instance method of +Prime+.instance can be accessed
# as a class method of +Prime+.
#
# e.g.
#   Prime.instance.prime?(2)  #=> true
#   Prime.prime?(2)           #=> true
#
# == Generators
#
# A "generator" provides an implementation of enumerating pseudo-prime
# numbers and it remembers the position of enumeration and upper bound.
# Furthermore, it is an external iterator of prime enumeration which is
# compatible with an Enumerator.
#
# +Prime+::+PseudoPrimeGenerator+ is the base class for generators.
# There are few implementations of generator.
#
# [+Prime+::+EratosthenesGenerator+]
#   Uses eratosthenes' sieve.
# [+Prime+::+TrialDivisionGenerator+]
#   Uses the trial division method.
# [+Prime+::+Generator23+]
#   Generates all positive integers which are not divisible by either 2 or 3.
#   This sequence is very bad as a pseudo-prime sequence. But this
#   is faster and uses much less memory than the other generators. So,
#   it is suitable for factorizing an integer which is not large but
#   has many prime factors. e.g. for Prime#prime? .
module Prime
  VERSION = "0.1.0"

  # def self.instance
  #   @@instance ||= new
  # end

  def self.each
    Generator::Eratosthenes.new
  end

  def self.each(upper_bound = nil, generator = Generator::Eratosthenes.new, &block)
    generator = Generator::Eratosthenes.new
    generator.upper_bound = upper_bound if upper_bound
    generator.each { |value| yield value }
  end

  # def each(ubound = nil, generator = Generator::Eratosthenes.new, &block)
  #   generator.upper_bound = ubound
  #   generator.each(&block)
  # end

  def self.prime?(value, generator = Generator::TwentyThree.new)
    return false if value < 2

    generator.each do |num|
      q, r = value.divmod num
      return true if q < num
      return false if r == 0
    end
  end

  def int_from_prime_division(pd)
    pd.inject(1) { |value, (prime, index)| value * prime**index }
  end

  def prime_division(value, generator = Generator::TwentyThree.new)
    raise ZeroDivisionError if value == 0

    if value < 0
      value = -value
      pv = [[-1, 1]]
    else
      pv = [] of Array(Int32)
    end

    generator.each do |prime|
      count = 0
      while (value1 = value.divmod(prime)[0]) == 0
        value = value1
        count += 1
      end

      pv.push([prime, count]) if count != 0
      break if value1 <= prime
    end

    pv.push([value, 1]) if value > 1

    pv
  end
end
