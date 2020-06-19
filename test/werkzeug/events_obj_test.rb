require_relative '../test_helper'
require_relative '../../lib/werkzeug/events'

class EventsObjTest < Test
  class TestConsumer
    attr_reader :fired

    def initialize
      @fired = []
    end

    %i[zero one two three four five].each do |name|
      define_method(name) { |_, _| @fired << name }
    end
  end

  def setup
    @consumer = TestConsumer.new
    @events = Werkzeug::Events.new
    @events.register(
      @consumer,
      zero: '*', one: 'a.b.c', two: '*.b.c', three: 'a.b.*', four: 'a.*.c'
    )
  end

  def assert_fired(event, *exp)
    @consumer.fired.clear
    @events.call(event)
    assert_equal(exp.sort!, @consumer.fired.sort!)
  end

  def test_fire
    assert_fired('a.b.c', :one, :two, :three, :four)
    assert_fired('x.b.c', :two)
    assert_fired('a.b.x', :three)
    assert_fired('a.x.c', :four)
    assert_fired('a.2x.c', :four)
    assert_fired('abc', :zero)
  end

  def test_register_result
    consumer = TestConsumer.new
    result = @events.register(consumer, one: 'one', two: 'two', three: 'other')
    assert_same(3, result.size)
  end

  def test_errors
    assert_raises(Werkzeug::Error::NoArgument) { @events.register(nil) }
    assert_raises(Werkzeug::Error::NoArgument) { @events.register(Object.new) }
    assert_raises_message(Werkzeug::Error::InvalidMethod, 'to_s') do
      @events.register(Object.new, to_s: 'a')
    end
  end
end
