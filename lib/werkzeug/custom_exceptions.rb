module Werkzeug
  module CustomExceptions
    def def_exception(name, parent = nil, format)
      const_set(name, create_exception(parent, format))
    end

    def create_exception(parent = nil, format)
      Class.new(_appropriate_parent(parent)) do
        extend(Extensions)
        const_set(:MESSAGE_FORMAT, format.freeze)
      end
    end

    private

    module Extensions
      def raise!(*args)
        message = format(self::MESSAGE_FORMAT, *args)
        raise(self, message, caller(1))
      end
    end

    def _appropriate_parent(obj)
      return self < ::Exception ? self : ::StandardError if obj.nil?
      return obj if obj.is_a?(::Class) && obj < ::Exception
      raise(::TypeError, 'exception class required', caller(2))
    end
  end
end
