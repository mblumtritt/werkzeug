# frozen_string_literal: true

require_relative 'host_os'

module Werkzeug
  module Terminal
    class << self
      def sync?
        $stdout.sync
      end

      def sync=(value)
        $stdout.sync = $stderr.sync = !!value
      end

      def tty?
        $stdout.tty?
      end

      def width
        @width ||= current_width
      end

      def with=(value)
        value = value.to_i
        @width = value < 10 ? current_width : value
      end

      def current_width
        return 80 unless tty? && HostOS.unix_like?
        ret = stty_width
        ret = tput_width if ret.zero?
        ret < 10 ? 80 : ret
      end

      private

      def stty_width
        `stty size 2>/dev/null`.split[1].to_i
      end

      def tput_width
        `tput cols 2>/dev/null`.to_i
      end
    end

    @width = nil
  end
end

