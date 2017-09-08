require 'minitest/autorun'
require 'minitest/parallel'
require 'minitest/proveit'

require_relative '../lib/werkzeug'

class Test < Minitest::Test
  parallelize_me!
  prove_it!

  def assert_raises_message(type = nil, message, &block)
    execption = assert_raises(type, &block)
    assert_equal(message, execption.message)
  end
end
