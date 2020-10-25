require_relative 'config'
require_relative 'error'

module Werkzeug
  class ThreadPool
    def self.default
      @default ||= new.tap { |pool| at_exit { pool.join } }
    end

    attr_reader :max_size

    def initialize(max_size = Config.default_thread_count)
      @max_size = max_size.clamp(0, max_size)
      @threads, @queue, @lock = {}, Queue.new, Monitor.new
      @condition = @lock.new_cond
    end

    def add(item)
      @queue.enq(item)
      start_thread
      item
    end

    def run(&block)
      block ? add(block) : Error::NoBlockGiven.raise!
    end

    def join
      @lock.synchronize { @condition.wait unless @threads.empty? }
    end

    def size
      @lock.synchronize { @threads.size }
    end

    private

    def start_thread
      @lock.synchronize do
        @threads[create_thread.__id__] = true if @threads.size < @max_size
      end
    end

    def create_thread
      Thread.new do
        break unless process_item while size <= @max_size
      ensure
        remove_thread(Thread.current)
      end
    end

    def remove_thread(thread)
      id = thread.__id__
      @lock.synchronize do
        @threads.delete(id)
        @condition.broadcast if @threads.empty?
      end
    end

    def process_item
      return false if @queue.empty?
      @queue.deq(true).call
      true
    rescue ThreadError
      false
    end
  end
end
