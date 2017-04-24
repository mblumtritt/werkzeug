module Werkzeug
  ROOT = __FILE__[0..-4].freeze
  autoload :Config, "#{ROOT}/config"
  autoload :CustomExceptions, "#{ROOT}/custom_exceptions"
  autoload :DataFile, "#{ROOT}/data_file"
  autoload :Events, "#{ROOT}/events"
  autoload :Future, "#{ROOT}/future"
  autoload :HostOS, "#{ROOT}/host_os"
  autoload :PidFile, "#{ROOT}/pid_file"
  autoload :ThreadPool, "#{ROOT}/thread_pool"
  autoload :VERSION, "#{ROOT}/version"

  def self.configure
    block_given? ? yield(Config) : Config 
  end

  def self.data_file
    DataFile.default
  end

  def self.events
    Events.default
  end

  def self.future(*args, &block)
    Future.new(*args, &block)
  end

  def self.host_os
    HostOS.type
  end

  def self.temp_dir
    HostOS.temp_dir
  end

  def self.thread_pool
    ThreadPool.default
  end
end
