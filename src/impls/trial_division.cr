class Impl::TrialDivision
  def self.instance
    @@instance ||= new
  end

  def initialize # :nodoc:
    # These are included as class variables to cache them for later uses.  If memory
    #   usage is a problem, they can be put in Prime#initialize as instance variables.

    # There must be no primes between @primes[-1] and @next_to_check.
    @primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101]
    # @next_to_check % 6 must be 1.
    @next_to_check = 103 # @primes[-1] - @primes[-1] % 6 + 7
    @ulticheck_index = 3 # @primes.index(@primes.reverse.find {|n|
    #   n < Math.sqrt(@@next_to_check) })
    @ulticheck_next_squared = 121 # @primes[@ulticheck_index + 1] ** 2
  end

  # Returns the +index+th prime number.
  #
  # +index+ is a 0-based index.
  def [](index)
    while index >= @primes.size
      # Only check for prime factors up to the square root of the potential primes,
      #   but without the performance hit of an actual square root calculation.
      if @next_to_check + 4 > @ulticheck_next_squared
        @ulticheck_index += 1
        @ulticheck_next_squared = @primes[@ulticheck_index + 1] ** 2
      end
      # Only check numbers congruent to one and five, modulo six. All others

      #   are divisible by two or three.  This also allows us to skip checking against
      #   two and three.
      @primes.push @next_to_check if @primes[2..@ulticheck_index].find { |prime| @next_to_check % prime == 0 }.nil?
      @next_to_check += 4
      @primes.push @next_to_check if @primes[2..@ulticheck_index].find { |prime| @next_to_check % prime == 0 }.nil?
      @next_to_check += 2
    end
    @primes[index]
  end
end
