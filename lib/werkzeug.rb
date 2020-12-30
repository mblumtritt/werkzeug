# frozen_string_literal: true

module Werkzeug
  lazy_load =
    lambda do |name, fname = name.to_s.downcase|
      autoload(name, File.expand_path("werkzeug/#{fname}", __dir__))
    end

  lazy_load[:Config]
  lazy_load[:Context]
  lazy_load[:CustomExceptions, 'custom_exceptions']
  lazy_load[:DataFile, 'data_file']
  lazy_load[:Delegate]
  lazy_load[:Events]
  lazy_load[:Future]
  lazy_load[:HashInspection, 'hash_inspection']
  lazy_load[:HostOS, 'host_os']
  lazy_load[:PidFile, 'pid_file']
  lazy_load[:PrefixedCalls, 'prefixed_calls']
  lazy_load[:SequenceFactory, 'sequence_factory']
  lazy_load[:Set]
  lazy_load[:Static]
  lazy_load[:Terminal]
  lazy_load[:ThreadPool, 'thread_pool']
  lazy_load[:ToolFunctions, 'tool_functions']
  lazy_load[:VERSION]

  def self.load!
    constants.each { |const| fname = autoload?(const) and require(fname) }
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

  def self.future(...)
    Future.new(...)
  end

  def self.host_os
    HostOS.type
  end

  def self.temp_dir
    HostOS.temp_dir
  end

  def self.terminal
    Terminal
  end

  def self.thread_pool
    ThreadPool.default
  end

  def self.create_static(...)
    Static.new(...)
  end

  def self.create_sequence
    SequenceFactory
  end
end

Werkzeug::TOP = self
