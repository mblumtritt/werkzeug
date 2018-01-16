require_relative '../test_helper'

class EventsTest < Test
  def test_register
    events = Werkzeug::Events.new
    received = []
    received_args = []
    events.register(:first, :second, :third) do |event, *args|
      received << event
      received_args << args
    end
    events.fire(:not_subscribed, 42)
    events.fire(:first, 1, 11)
    events.fire(:second, 2, 22, 222)
    assert_equal(%i[first second], received)
    assert_equal([[1, 11], [2, 22, 222]], received_args)
  end

  def test_register_any
    events = Werkzeug::Events.new
    received = []
    events.register(:any) do |event, *_|
      received << event
    end
    events.fire(:first)
    events.fire(:second)
    events.fire(:thirth)
    assert_equal(%i[first second thirth], received)
  end

  def test_unregister
    events = Werkzeug::Events.new
    received = []
    id = events.register(:first, :second, :third) do |event, *_|
      received << event
    end
    events.unregister(id, :second)
    events.fire(:first)
    events.fire(:second)
    events.fire(:third)
    assert_equal(%i[first third], received)
  end

  def test_reset
    events = Werkzeug::Events.new
    received = []
    events.register(:first, :second, :third) do |event, *args|
      received << event
    end
    events.reset(:first, :second)
    events.fire(:first)
    events.fire(:second)
    events.fire(:third)
    assert_equal(%i[third], received)
  end
end
