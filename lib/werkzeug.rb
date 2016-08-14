module Werkzeug
  ROOT = __FILE__.gsub(/\.rb$/, '').freeze
  autoload :VERSION, "#{ROOT}/version"
  autoload :CustomExceptions, "#{ROOT}/custom_exceptions"
  autoload :Config, "#{ROOT}/config"
  autoload :ThreadPool, "#{ROOT}/thread_pool"
  autoload :Future, "#{ROOT}/future"
  autoload :Events, "#{ROOT}/events"
  autoload :DataFile, "#{ROOT}/data_file"
  autoload :PidFile, "#{ROOT}/pid_file"

  def self.configure
    yield(Config) if block_given?
  end

  def self.thread_pool
    ThreadPool.default
  end

  def self.future(*args, &block)
    Future.new(*args, &block)
  end

  def self.events
    Events.default
  end
end
