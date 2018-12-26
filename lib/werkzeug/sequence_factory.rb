module Werkzeug
  module SequenceFactory
    def self.loop(*array)
      i = 0
      proc do
        ret = array[i]
        i += 1
        i = 0 if i == array.size
        ret
      end
    end

    def self.ping_pong(*array)
      i, d = 0, 1
      proc do
        ret = array[i]
        i += d
        d = -d if i == array.size - 1 || i.zero?
        ret
      end
    end

    def self.random(*array)
      proc{ array.sample }
    end
  end
end
