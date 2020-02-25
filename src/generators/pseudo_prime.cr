# An abstract class for enumerating pseudo-prime numbers.
#
# Concrete subclasses should override succ, next, rewind.
class Generator::PseudoPrime
  include Enumerable(Int32)

  def initialize(ubound : Int32? = nil)
    @ubound = ubound
  end

  def upper_bound=(ubound)
    @ubound = ubound
  end

  def upper_bound
    @ubound
  end

  def succ
    raise NotImplementedError.new("need to define `succ'")
  end

  def next
    raise NotImplementedError.new("need to define `next'")
  end

  def rewind
    raise NotImplementedError.new("need to define `rewind'")
  end

  def each
    self.dup
  end

  def each(&block)
    if @ubound
      last_value = nil
      loop do
        prime = succ
        break last_value if prime > @ubound.not_nil!
        last_value = yield prime
      end
    else
      loop do
        yield succ
      end
    end
  end

  # see +Enumerator+#with_index.
  def with_index(offset = 0)
    return GeneratorIterator.new(self, offset)
  end

  # see +Enumerator+#with_index.
  def with_index(offset = 0, &block)
    # return enum_for(:with_index, offset) { Int32::MAX } unless block
    return each_with_index { |p, i| yield p, i } if offset == 0

    each do |prime|
      yield prime, offset
      offset += 1
    end
  end

  # see +Enumerator+#with_object.
  def with_object(obj)
    return GeneratorIterator.new(self)
  end

  # see +Enumerator+#with_object.
  def with_object(obj, &block)
    each do |prime|
      yield prime, obj
    end
  end

  def size
    Int32::MAX
  end

  private class GeneratorIterator(PseudoPrimeGenerator)
    include Iterator(Int32)

    def initialize(@generator : PseudoPrimeGenerator, @offset = 0)
    end

    def next
      # if @offset >= @generator.size
      #   stop
      # else
        value = @offset
        @offset += 1
        value
      # end
    end
  end
end
