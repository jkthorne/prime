# An implementation of +PseudoPrimeGenerator+.
#
# Uses +EratosthenesSieve+.
class Generator::Eratosthenes < Generator::PseudoPrime
  def initialize
    @last_prime_index = -1
    super
  end

  def succ
    @last_prime_index += 1
    Impl::EratosthenesSieve.instance.get_nth_prime(@last_prime_index)
  end

  def rewind
    initialize
  end

  def next
    succ
  end
end
