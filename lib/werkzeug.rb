# frozen_string_literal: true

module Werkzeug
  ROOT = __FILE__[0..-4]
  autoload :Config, "#{ROOT}/config"
  autoload :Context, "#{ROOT}/context"
  autoload :CustomExceptions, "#{ROOT}/custom_exceptions"
  autoload :DataFile, "#{ROOT}/data_file"
  autoload :Delegate, "#{ROOT}/delegate"
  autoload :Events, "#{ROOT}/events"
  autoload :Future, "#{ROOT}/future"
  autoload :HashInspction, "#{ROOT}/hash_inspection"
  autoload :HostOS, "#{ROOT}/host_os"
  autoload :PidFile, "#{ROOT}/pid_file"
  autoload :ThreadPool, "#{ROOT}/thread_pool"
  autoload :Set, "#{ROOT}/set"
  autoload :SequenceFactory, "#{ROOT}/sequence_factory"
  autoload :ToolFunctions, "#{ROOT}/tool_functions"
  autoload :PrefixedCalls, "#{ROOT}/prefixed_calls"
  autoload :VERSION, "#{ROOT}/version"

  def self.load!
    constants.each { |const| fn = autoload?(const) and require(fn) }
  end

  def self.configure
    block_given? ? yield(Config) : Config
  end

  def self.include_tools!
    TOP.instance_exec { include ToolFunctions }
  end

  def self.context
    Context.default
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

  def self.create_sequence
    SequenceFactory
  end
end

Werkzeug::TOP = self
