require_relative 'error'

module Werkzeug
  module SequenceFactory
    def self.loop(*array)
      return proc {} if array.empty?
      i = 0
      proc do
        ret = array[i]
        i += 1
        i = 0 if i == array.size
        ret
      end
    end

    def self.ping_pong(*array)
      return proc {} if array.empty?
      i, d = 0, 1
      proc do
        ret = array[i]
        i += d
        d = -d if i == array.size - 1 || i == 0
        ret
      end
    end

    def self.random(*array)
      array.empty? ? proc {} : proc { array.sample }
    end

    def self.linear(*args)
      case args.size
      when 0
        Linear
      when 2
        Linear.create(*args, 1)
      when 3
        Linear.create(*args)
      else
        Error::ArgumentCount.raise!(args.size, 2..3)
      end
    end

    module Linear
      def self.create(from, to, delta)
        delta = -delta if delta < 0
        from < to ? Linear.up(from, to, delta) : Linear.down(from, to, delta)
      end

      def self.up(from, to, delta)
        return proc { from } if from == to
        i = from
        proc do
          ret = i
          i = from if (i += delta) > to
          ret
        end
      end

      def self.down(from, to, delta)
        return proc { from } if from == to
        i = from
        proc do
          ret = i
          i = from if (i -= delta) < to
          ret
        end
      end

      def self.ping_pong(from, to, delta)
        return proc { from } if from == to
        i = from
        proc do
          ret = i
          i += delta
          if i <= from
            i, delta = from, -delta
          elsif i >= to
            i, delta = to, -delta
          end
          ret
        end
      end
    end
  end
end
