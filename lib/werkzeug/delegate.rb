# frozen_string_literal: true

require_relative 'error'

module Werkzeug
  module Delegate
    private def delegate(
      *method_names, to:, prefix: false, private: false, allow_nil: false
    )
      Error::InvalidArgumentType.raise!(:to, to.inspect) unless to
      location = caller_locations(1, 1).first
      prefix = prefix ? "#{prefix == true ? to : prefix}_" : ''
      method_names.each do |name|
        code = "def #{prefix}#{name}(...);#{to}"
        code += '&' if allow_nil
        code += ".#{name}(...);end"
        module_eval(code, location.path, location.lineno)
      end
      private(*method_names) if private
      method_names
    end
  end
end
