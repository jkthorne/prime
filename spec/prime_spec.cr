require "./spec_helper"

PRIMES = [
  2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37,
  41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83,
  89, 97, 101, 103, 107, 109, 113, 127, 131,
  137, 139, 149, 151, 157, 163, 167, 173, 179,
  181, 191, 193, 197, 199, 211, 223, 227, 229,
  233, 239, 241, 251, 257, 263, 269, 271, 277,
  281, 283, 293, 307, 311, 313, 317, 331, 337,
  347, 349, 353, 359, 367, 373, 379, 383, 389,
  397, 401, 409, 419, 421, 431, 433, 439, 443,
  449, 457, 461, 463, 467, 479, 487, 491, 499,
  503, 509, 521, 523, 541,
]

class PrimeTest
  property! name
end

describe Prime do
  it "each of initial 100" do
    primes = [] of Int32

    Prime.each do |p|
      break if p > 541
      primes << p
    end

    primes.should eq PRIMES
  end

  # it "each by prime number theorem" do
  #   3.upto(15) do |i|
  #     max = 2**i
  #     primes = [] of Int32

  #     Prime.each do |p|
  #       next if p >= max
  #       primes << p
  #     end

  #     # Prime number theorem
  #     (primes.size >= (max / Math.log(max))).should eq(true)
  #     # delta = 0.05
  #     # li = (2..max).step(delta).to_a.inject(0) { |sum, x| sum + delta/Math.log(x) }
  #     # (primes.size <= li).should eq(true)

  #     sum = 0.0
  #     step = 2.0
  #     delta = 0.05
  #     while (step >= max)
  #       sum = sum + delta / Math.log(step)
  #       step += delta
  #     end

  #     (primes.size <= sum).should eq(true)
  #   end
  # end

  it "each without block" do
    xenum = Prime.each
    xenum.is_a?(Enumerable)
  end

  # it "instance each without block" do
  #   xenum = Prime.instance.each
  #   xenum.is_a?(Enumerable)
  # end

  it "enumerator next" do
    xenum = Prime.each
    50.times.map{ xenum.succ }.to_a.should eq PRIMES[0, 50]
    50.times.map{ xenum.succ }.to_a.should eq PRIMES[50, 50]
    xenum.rewind
    100.times.map{ xenum.succ }.to_a.should eq PRIMES[0, 100]
  end

  it "enumerator with index" do
    xenum = Prime.each
    last = -1

    xenum.with_index do |p, i|
      break if i >= 100
      i.should eq(last + 1)
      p.should eq(PRIMES[i])
      last = i
    end
  end

  # it "enumerator with index with offsets" do
  #   xenum = Prime.each
  #   last = 5 - 1

  #   xenum.with_index(5).each do |p, i|
  #     break if i >= 100 + 5
  #     i.should eq(last + 1)
  #     p.should eq(PRIMES[i - 5])
  #     last = i
  #   end
  # end

  # it "enumerator with object" do
  #   object = PrimeTest.new
  #   xenum = Prime.each
  #   xenum.with_object(object).each do |p, o|
  #     o.should eq(object)
  #     break
  #   end
  # end

  it "enumerator size" do
    xenum = Prime.each
    xenum.size.should eq(Int32::MAX)
    # xenum.with_object(nil).size.should eq(Int32::MAX)
    # xenum.with_index(42).size.should eq(Int32::MAX)
  end

  it "#prime?" do
    Prime.prime?(1).should eq(false)
    Prime.prime?(2).should eq(true)
    Prime.prime?(4).should eq(false)
  end

  describe Generator::PseudoPrime do
    it "#upper_bound" do
      pseudo_prime_generator = Generator::PseudoPrime.new(42)
      pseudo_prime_generator.upper_bound.should eq 42
    end

    it "#succ" do
      pseudo_prime_generator = Generator::PseudoPrime.new(42)
      expect_raises(NotImplementedError) { pseudo_prime_generator.succ }
    end

    it "#next" do
      pseudo_prime_generator = Generator::PseudoPrime.new(42)
      expect_raises(NotImplementedError) { pseudo_prime_generator.next }
    end

    it "#rewind" do
      pseudo_prime_generator = Generator::PseudoPrime.new(42)
      expect_raises(NotImplementedError) { pseudo_prime_generator.rewind }
    end
  end

  describe Generator::TrialDivision do
    it "#each" do
      primes = [] of Int32

      Prime.each(generator: Generator::TrialDivision.new) do |p|
        break if p > 541
        primes << p
      end

      primes.should eq PRIMES
    end

    it "#rewind" do
      generator = Generator::TrialDivision.new
      generator.next.should eq(2)
      generator.next.should eq(3)
      generator.rewind
      generator.next.should eq(2)
    end
  end

  describe Generator::TwentyThree do
    it "#rewind" do
      generator = Generator::TwentyThree.new
      generator.next.should eq(2)
      generator.next.should eq(3)
      generator.rewind
      generator.next.should eq(2)
    end
  end
end
