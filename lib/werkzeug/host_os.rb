# frozen_string_literal: true

module Werkzeug
  module HostOS
    class << self
      def name
        RbConfig::CONFIG['host_os']
      end

      def linux?
        /linux/.match?(name)
      end

      def mac_os?
        /darwin|mac os/.match?(name)
      end

      def windows?
        /mswin|mingw|cygwin/.match?(name)
      end

      def type
        @type ||= find_type
      end

      private

      def find_type
        return :linux if linux?
        return :mac_os if mac_os?
        return :windows if windows?
        nil
      end
    end
  end
end
