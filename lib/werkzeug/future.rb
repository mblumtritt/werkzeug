require_relative 'thread_pool'
require_relative 'error'

module Werkzeug
  class Future
    def initialize(*args, thread_pool: ThreadPool.default, **opts, &block)
      Error::NoBlockGiven.raise! unless block
      @function = -> { block.call(*args, **opts) }
      @value = @error = NOT_SET
      @lock = Mutex.new
      thread_pool.add(self)
    end

    def wait
      @lock.synchronize { chore } if @function
      self
    end

    def value
      wait.error? ? raise(@error) : @value
    end

    def value?
      set?(@value)
    end

    def error?
      set?(@error)
    end

    def avail?
      @function.nil?
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
      @value = @function.call if @function
    rescue Exception => error
      @error = error
    ensure
      @function = nil
    end

    NOT_SET = BasicObject.new
    private_constant(:NOT_SET)
  end
end
