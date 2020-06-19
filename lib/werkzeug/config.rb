# frozen_string_literal: true

module Werkzeug
  Config =
    Class.new do
      attr_writer :default_thread_count

      def initialize
        @default_thread_count = @suggested_thread_count = nil
      end

      def default_thread_count
        @default_thread_count || suggested_thread_count
      end

      def suggested_thread_count
        @suggested_thread_count ||= find_suggested_thread_count
      end

      private

      def find_suggested_thread_count
        count = ENV['TC'].to_i
        return count unless count.zero?
        require 'etc' unless defined?(Etc)
        Etc.nprocessors
      end
    end.new
end
