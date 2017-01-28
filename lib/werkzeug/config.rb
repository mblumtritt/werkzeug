# frozen_string_literal: true

module Werkzeug
  module Config
    class << self
      def default_thread_count=(count)
        @@default_thread_count = count
      end

      def default_thread_count
        @@default_thread_count || suggested_thread_count
      end

      def suggested_thread_count
        @@suggested_thread_count ||= find_suggested_thread_count
      end

      private

      @@default_thread_count = @@suggested_thread_count = nil

      def find_suggested_thread_count
        count = ENV['TC'].to_i
        return count unless count.zero?
        require 'etc' unless defined?(Etc)
        Etc.nprocessors
      end
    end
  end
end
