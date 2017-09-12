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
        /msdos|mswin|djgpp|msys|mingw|cygwin|bccwin|wince|emc|windows/i.match?(name)
      end

      def unix?
        /(aix|(net|free|open)bsd|solaris|irix|hpux)/i.match?(name)
      end

      def unix_like?
        unix? || linux? || mac_os? || /cygwin/.match?(name)
      end

      def type
        @@type ||= find_type
      end

      def temp_dir
        @@temp_dir ||= find_temp_dir
      end

      private

      @@type = @@temp_dir = nil

      def find_type
        return :linux if linux?
        return :mac_os if mac_os?
        return :unix if unix?
        return :windows if windows?
        nil
      end

      def find_temp_dir
        test_dir(ENV['TMPDIR']) ||
          test_dir(ENV['TMP']) ||
          test_dir(ENV['TEMP']) ||
          test_dir('./tmp') ||
          test_dir(defined?(Etc.systmpdir) ? Etc.systmpdir : '/tmp')
      end

      def test_dir(dir)
        return nil unless dir
        dir = File.expand_path(dir)
        valid_dir?(dir) ? dir : nil
      end

      def valid_dir?(dir)
        return (s = File.stat(dir) and s.directory? and s.writable? and (!s.world_writable? or s.sticky?)) rescue false
      end
    end
  end
end
