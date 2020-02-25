# Generates all integers which are greater than 2 and
# are not divisible by either 2 or 3.
#
# This is a pseudo-prime generator, suitable on
# checking primality of an integer by brute force
# method.
class Generator::TwentyThree < Generator::PseudoPrime
  def initialize
    @prime = 1
    @step = nil
    super
  end

  def succ
    if @step
      @prime += @step.not_nil!
      @step = 6 - @step.not_nil!
    else
      case @prime
      when 1; @prime = 2
      when 2; @prime = 3
      when 3; @prime = 5; @step = 2
      end
    end
    @prime
  end

  def next
    succ
  end

  def rewind
    initialize
  end
end
