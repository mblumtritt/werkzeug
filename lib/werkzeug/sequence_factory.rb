module Werkzeug
  module SequenceFactory
    def self.loop(*array)
      array, i = array.flatten, 0
      proc do
        ret = array[i]
        i += 1
        i = 0 if i == array.size
        ret
      end
    end

    def self.ping_pong(*array)
      array, i, d = array.flatten, 0, 1
      proc do
        ret = array[i]
        i += d
        d = -d if i == array.size - 1 || i == 0
        ret
      end
    end

    def self.random(*array)
      array = array.flatten
      proc{ array.sample }
    end
  end
end
