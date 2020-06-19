require_relative '../test_helper'
require_relative '../../lib/werkzeug/events'

class EventTest < Test
  def setup
    @events = Werkzeug::Events.new
  end

  def test_defaults
    assert_empty(@events)
    assert_same(0, @events.size)
  end

  def test_reset
    @events.on('a', 'b') {}
    refute_empty(@events)
    assert_same(2, @events.size)

    @events.reset!
    assert_empty(@events)
    assert_same(0, @events.size)
  end

  def test_errors
    assert_raises(ArgumentError) { @events.call }
    assert_raises(Werkzeug::Error::InvalidEventName) { @events.call('') }
  end
end
