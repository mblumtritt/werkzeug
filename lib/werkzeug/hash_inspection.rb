# frozen_string_literal: true

module Werkzeug
  module HashInspection
    def inspect
      return super unless defined?(to_h)
      details = to_h.map { |k, v| "#{k}:#{v.inspect}" }.join(', ')
      if defined?(self.class)
        "#<#{self.class}::#{__id__} #{details}>"
      else
        "#<<#{__id__} #{details}>>"
      end
    end
  end
end
