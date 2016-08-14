require_relative 'error'

module Werkzeug
  class Events
    def self.global
      @global ||= new
    end

    def initialize
      @reg = Hash.new{ |h, k| h[k] = {} }
      @lock = Monitor.new
    end

    def call(event, *args)
      @lock.synchronize do
        _fire(@reg[event], event, args)
        _fire(@reg[:any], event, args)
      end
      self
    end
    alias fire call

    def register(*events, &block)
      Error::NoArgument.raise! if events.empty?
      Error::NoBlockGiven.raise! unless block
      id = block.__id__
      events.uniq!
      @lock.synchronize{ _register(id, block, events) }
      id
    end

    def unregister(listener, *events)
      id = Numeric === listener ? listener : listener.__id__
      events.uniq!
      @lock.synchronize{ events.empty? ? _unregister_all(id) : _unregister(id, events) }
      id
    end

    def reset(*events)
      Error::NoArgument.raise! if events.empty?
      events.uniq!
      @lock.synchronize{ _reset(events) }
    end

    private

    def _fire(targets, event, args)
      targets.each_value{ |block| block.call(event, *args) }
    end

    def _register(id, block, events)
      events.each do |event|
        reg = @reg[event]
        reg.delete(id) # to re-order if already registered
        reg[id] = block
      end
    end

    def _unregister_all(id)
      @reg.each_value{ |reg| reg.delete(id) }
    end

    def _unregister(id, events)
      events.each{ |event| @reg[event].delete(id) }
    end

    def _reset(events)
      events.each{ |event| @reg.delete(event) }
    end
  end
end
