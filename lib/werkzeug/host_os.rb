# frozen_string_literal: true

module Werkzeug
  module HostOS
    def self.name
      RbConfig::CONFIG['host_os']
    end

    def self.linux?
      /linux/.match?(name)
    end

    def self.mac_os?
      /darwin|mac os/.match?(name)
    end

    def self.windows?
      /mswin|mingw|cygwin/.match?(name)
    end

    def self.type
      @type ||= case
      when linux?
        :linux
      when mac_os?
        :mac_os
      when windows?
        :windows
      else
        nil
      end
    end
  end
end
