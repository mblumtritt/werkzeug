require_relative '../test_helper'
require_relative '../../lib/werkzeug/events'

class EventsProcTest < Test
  def setup
    @events = Werkzeug::Events.new
    # @fired = nil
    @events.on('*'){      @fired << 0 }
    @events.on('a', 'b'){ @fired << 1 }
    @events.on('b', 'c'){ @fired << 2 }
    @events.on('a.b.c'){  @fired << 3 }
    @events.on('*.b.c'){  @fired << 4 }
    @events.on('a.b.*'){  @fired << 5 }
    @events.on('a.*.c'){  @fired << 6 }
  end

  def assert_fired(event, *exp)
    @fired = []
    @events.call(event)
    assert_equal(exp.sort!, @fired.sort!)
  end

  def test_fire
    assert_fired('a',      0, 1)
    assert_fired('b',      0, 1, 2)
    assert_fired('c',      0, 2)
    assert_fired('x',      0)
    assert_fired('a.b.c',  3, 4, 5, 6)
    assert_fired('x.b.c',  4)
    assert_fired('a.b.x',  5)
    assert_fired('a.x.c',  6)
    assert_fired('a.x2.c', 6)
  end

  def test_remove
    id = @events.on('x'){  @fired << 42 }
    assert_fired('x', 0, 42)
    @events.remove(id)
    assert_fired('x', 0)
  end

  def test_remove_all
    @events.on('x.y'){ @fired << 111 }
    @events.on('x.2'){ @fired << 222 }
    @events.on('x.*'){ @fired << 333 }
    assert_fired('x.y', 111, 333)
    assert_fired('x.2', 222, 333)
    @events.remove_all('x')
    assert_fired('x.y')
    assert_fired('x.2')
  end

  def test_remove_on_fire
    @fired = []
    old_size = @events.size
    id = @events.on('a'){ @events.remove(id) }
    assert_same(old_size + 1, @events.size)
    @events.fire('a')
    assert_same(old_size, @events.size)
    assert_equal([0, 1], @fired.sort!)
  end

  def test_errors
    assert_raises(Werkzeug::Error::NoArgument){ @events.on }
    assert_raises(Werkzeug::Error::InvalidEventName){ @events.on('') }
    assert_raises(Werkzeug::Error::NoBlockGiven){ @events.on('a') }
  end
end
