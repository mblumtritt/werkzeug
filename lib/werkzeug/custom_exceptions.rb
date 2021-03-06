# frozen_string_literal: true

module Werkzeug
  module CustomExceptions
    def def_exception(name, parent = nil, format)
      const_set(name, create_exception(parent, format))
    end

    def create_exception(parent = nil, format)
      Class.new(appropriate_parent(parent)) do
        const_set(:MESSAGE_FORMAT, String.new(format.to_s).freeze)
        extend(Extensions)
      end
    end

    private

    def appropriate_parent(obj)
      return self < ::Exception ? self : ::StandardError if obj.nil?
      return obj if obj.is_a?(::Class) && obj < ::Exception
      raise(::TypeError, 'exception class required', caller(2))
    end

    module Extensions
      def raise!(*args)
        message = format(self::MESSAGE_FORMAT, *args)
        raise(self, message, caller(1))
      end
    end
  end
end
