module Werkzeug
  module Config
    def self.default_thread_count=(count)
      @default_thread_count = count
    end

    def self.default_thread_count
      @default_thread_count ||= suggested_thread_count
    end

    def self.suggested_thread_count
      count = ENV['TC'].to_i
      return count unless count.zero?
      require 'etc' unless defined?(Etc)
      Etc.nprocessors
    end
  end

  Config.default_thread_count = nil
end
