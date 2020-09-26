require 'minitest/autorun'
require 'minitest/parallel'
require_relative '../lib/werkzeug'

Werkzeug.load!

class Test < Minitest::Test
  parallelize_me!

  def assert_raises_message(type, message, &block)
    execption = assert_raises(type, &block)
    assert_match(message, execption.message)
  end
end
