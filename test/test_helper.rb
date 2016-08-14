require 'minitest/autorun'
require 'minitest/hell'
require_relative '../lib/werkzeug'

class StandardTest < Minitest::Test
  def assert_raises_message(type = nil, message, &block)
    execption = assert_raises(type, &block)
    assert_equal(message, execption.message)
  end
end
