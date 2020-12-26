require_relative 'error'

module Werkzeug
  module SequenceFactory
    def self.loop(*array)
      return proc {} if array.empty?
      i = 0
      proc do
        ret = array[i]
        i = 0 if (i += 1) == array.size
        ret
      end
    end

    def self.ping_pong(*array)
      return proc {} if array.empty?
      i, d = 0, 1
      proc do
        ret = array[i]
        d = -d if (i += d) == array.size - 1 || i == 0
        ret
      end
    end

    def self.random(*array)
      max = array.size - 1
      max < 0 ? proc {} : proc { array[Random.rand(max)] }
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
      class << self
        def create(from, to, delta)
          return proc { from } if from == to
          return up(from, to, delta.abs) if from < to
          down(from, to, delta.abs)
        end

        def ping_pong(from, to, delta)
          return proc { from } if from == to
          return ping(from, to, delta.abs) if from < to
          pong(from, to, -delta.abs)
        end

        private

        def up(from, to, delta, i = from)
          proc do
            ret = i
            i = from if (i += delta) > to
            ret
          end
        end

        def down(from, to, delta, i = from)
          proc do
            ret = i
            i = from if (i -= delta) < to
            ret
          end
        end

        def ping(from, to, delta, i = from)
          proc do
            ret = i
            if (i += delta) <= from
              i, delta = from, -delta
            elsif i >= to
              i, delta = to, -delta
            end
            ret
          end
        end

        def pong(from, to, delta, i = from)
          proc do
            ret = i
            if (i += delta) < to
              delta = -delta
              i = to + delta
            elsif i > from
              delta = -delta
              i = from + delta
            end
            ret
          end
        end
      end
    end
  end
end
