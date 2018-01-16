require_relative '../test_helper'
require_relative '../../lib/werkzeug/error'

class ErrorTest < Test
  ERROR_CLASSES = [
      Werkzeug::Error::NoBlockGiven,
      Werkzeug::Error::NoArgument,
      Werkzeug::Error::ArgumentCount,
      Werkzeug::Error::MethodExpected,
      Werkzeug::Error::DoublicateArgumentNames
    ].freeze

  def test_types
    ([Werkzeug::Error] + ERROR_CLASSES).each do |error|
      assert(error < ::ArgumentError)
    end
  end

  def test_constants
    ERROR_CLASSES.each do |error|
      assert(defined?(error::MESSAGE_FORMAT))
      assert(error::MESSAGE_FORMAT.is_a?(String))
    end
  end

  def test_method
    ERROR_CLASSES.each do |error|
      assert_equal('method', defined?(error::raise!))
    end
  end
end
