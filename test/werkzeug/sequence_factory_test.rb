require_relative '../test_helper'

class SequenceFactoryTest < Test
  def test_loop
    subject = Werkzeug::SequenceFactory.loop(1, 2, 3, 4)
    expectation = [1, 2, 3, 4, 1, 2, 3, 4, 1, 2]
    assert_equal(expectation, Array.new(10, &subject))

    subject = Werkzeug::SequenceFactory.loop(1, [2, 3], [4])
    expectation = [1, [2, 3], [4], 1, [2, 3], [4], 1, [2, 3], [4], 1]
    assert_equal(expectation, Array.new(10, &subject))

    subject = Werkzeug::SequenceFactory.loop
    assert(Array.new(10, &subject).all?(&:nil?))
  end

  def test_ping_pong
    subject = Werkzeug::SequenceFactory.ping_pong(1, 2, 3, 4)
    expectation = [1, 2, 3, 4, 3, 2, 1, 2, 3, 4]
    assert_equal(expectation, Array.new(10, &subject))

    subject = Werkzeug::SequenceFactory.ping_pong(1, [2, 3], 4)
    expectation = [1, [2, 3], 4, [2, 3], 1, [2, 3], 4, [2, 3], 1, [2, 3]]
    assert_equal(expectation, Array.new(10, &subject))

    subject = Werkzeug::SequenceFactory.ping_pong
    assert(Array.new(10, &subject).all?(&:nil?))
  end

  def test_random
    elements = [1, 2, 3, 4].freeze
    subject = Werkzeug::SequenceFactory.random(*elements)
    10.times { assert_includes(elements, subject.call) }

    elements = [1, [2, 3], 4].freeze
    subject = Werkzeug::SequenceFactory.random(*elements)
    10.times { assert_includes(elements, subject.call) }

    subject = Werkzeug::SequenceFactory.random
    assert(Array.new(10, &subject).all?(&:nil?))
  end
end
