module Werkzeug
  ROOT = __FILE__[0..-4].freeze
  autoload :VERSION, "#{ROOT}/version"
  autoload :CustomExceptions, "#{ROOT}/custom_exceptions"
  autoload :Config, "#{ROOT}/config"
  autoload :ThreadPool, "#{ROOT}/thread_pool"
  autoload :Future, "#{ROOT}/future"
  autoload :Events, "#{ROOT}/events"
  autoload :DataFile, "#{ROOT}/data_file"
  autoload :PidFile, "#{ROOT}/pid_file"
  autoload :HostOS, "#{ROOT}/host_os"

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

  def self.host_os
    HostOS.type
  end
end
