require 'minitest/autorun'
require 'minitest/parallel'
require 'minitest/proveit'

require_relative '../lib/werkzeug'
Werkzeug.load! # avoid load conflicts in threads

class Test < Minitest::Test
  parallelize_me!
  prove_it!

  def assert_raises_message(type = nil, message, &block)
    execption = assert_raises(type, &block)
    assert_match(message, execption.message)
  end
end
