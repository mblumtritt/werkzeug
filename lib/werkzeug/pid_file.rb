require_relative 'custom_exceptions'
require_relative 'host_os'

module Werkzeug
  module PidFile
    class Error < StandardError
      extend CustomExceptions
      DuplicateProcess = create_exception('process already running - %u')
      FLock = create_exception('unable to lock file - %s')
    end

    class << self
      def read_pid(file_name)
        pid = File.readable?(file_name) ? File.read(file_name).chomp.to_i : 0
        pid.nonzero? && process_exists?(pid) ? pid : nil
      end

      def pid_or_create(file_name)
        read_pid(file_name) || create_file(file_name)
      end

      def try_create(file_name = default_file_name)
        pid_or_create(file_name).is_a?(String)
      end

      def create(file_name = default_file_name)
        pos = pid_or_create(file_name)
        pos.is_a?(String) ? Error::DuplicateProcess.raise!(pos) : pos
      end

      def default_file_name
        File.join(HostOS.temp_dir,"#{File.basename($PROGRAM_NAME)}.pid")
      end

      private

      def create_file(file_name)
        file = File.open(file_name, 'w'.freeze)
        Error::FLock.raise!(file_name) unless file.flock(File::LOCK_EX | File::LOCK_NB)
        file.puts(Process.pid)
        file.flush
        at_exit do
          file.flock(File::LOCK_UN)
          File.unlink(file_name)
        end
        file_name
      end

      def process_exists?(pid)
        !!Process.kill(0, pid)
      rescue Errno::ESRCH
        false
      end
    end
  end
end
