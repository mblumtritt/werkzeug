require_relative 'config'

module Werkzeug
  class ThreadPool
    def self.default
      @pool ||= new.tap do |pool|
        at_exit{ pool.join }
      end
    end

    attr_reader :max_size

    def initialize(max_size = Config.default_thread_count)
      @max_size = 0 < max_size ? max_size : 0
      @threads, @queue, @lock = {}, Queue.new, Monitor.new
      @condition = @lock.new_cond
    end

    def add(item)
      @queue.enq(item)
      start_thread
      item
    end

    def run(&block)
      return false unless block
      add(block)
      nil
    end

    def join
      @lock.synchronize{ @condition.wait unless @threads.empty? }
    end

    def size
      @lock.synchronize{ @threads.size }
    end

    private

    def start_thread
      @lock.synchronize{ @threads[create_thread] = true if @threads.size < @max_size }
    end

    def create_thread
      Thread.new do
        begin
          while size <= @max_size
            break unless process_item
          end
        ensure
          remove_thread(Thread.current)
        end
      end
    end

    def remove_thread(thread)
      @lock.synchronize do
        @threads.delete(thread)
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
