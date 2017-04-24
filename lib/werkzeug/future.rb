require_relative 'thread_pool'
require_relative 'error'

module Werkzeug
  class Future
    def initialize(*args, &block)
      Error::NoBlockGiven.raise! unless block
      @value = @error = NOT_SET
      @lock, @args, @function = Mutex.new, args, block
      ThreadPool.default.add(self)
    end

    def value
      @lock.synchronize{ chore } unless avail?
      error? ? raise(@error) : @value
    end

    def value?
      set?(@value)
    end

    def error?
      set?(@error)
    end

    def avail?
      value? || error?
    end

    def call
      return unless @lock.try_lock
      begin
        chore
      ensure
        @lock.unlock
      end
    end

    private

    def set?(value)
      NOT_SET.__id__ != value.__id__
    end

    def chore
      return if avail?
      begin
        @value = @function.call(*@args)
      rescue Exception => error
        @error = error
      ensure
        @function = @args = nil
      end
    end

    NOT_SET = BasicObject.new
    private_constant :NOT_SET
  end
end
