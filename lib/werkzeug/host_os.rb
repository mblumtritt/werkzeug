# frozen_string_literal: true

module Werkzeug
  module HostOS
    class << self
      def name
        @name ||= RbConfig::CONFIG['host_os'].downcase
      end

      def type
        @type ||= MAP.keys.find { |type| check_type(type) }
      end

      %i[linux mac_os windows unix].each do |name|
        define_method("#{name}?") { type == name }
      end

      def unix_like?
        unix? || linux? || mac_os? || check_type(:cygwin)
      end

      def temp_dir
        @temp_dir ||= find_temp_dir
      end

      private

      MAP = {
        linux: %w[linux],
        mac_os: ['darwin', 'mac os'],
        unix: %w[netbsd freebsd openbsd aix solaris irix hpux],
        windows: %w[
          msdos
          mswin
          djgpp
          msys
          mingw
          cygwin
          bccwin
          wince
          emc
          windows
        ],
        cygwin: %w[cygwin] # must be last in the map!
      }.freeze

      def check_type(type, name = self.name)
        MAP[type].any? { |mark| name.index(mark) }
      end

      def find_temp_dir
        test_dir(ENV['TMPDIR']) || test_dir(ENV['TMP']) ||
          test_dir(ENV['TEMP']) || sys_temp? || test_dir('./tmp') ||
          test_dir('.') || test_dir('.,')
      end

      def sys_temp?
        require 'etc' unless defined?(Etc)
        test_dir(Etc.systmpdir)
      end

      def test_dir(dir)
        return unless dir
        dir = File.expand_path(dir)
        valid_dir?(dir) ? dir : nil
      end

      def valid_dir?(dir)
        (
          s = File.stat(dir) and s.directory? and s.writable? and
            (!s.world_writable? or s.sticky?)
        )
      rescue StandardError
        false
      end
    end
  end
end
