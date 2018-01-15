require_relative '../test_helper'

class SequenceFactoryTest < Test
  def test_loop
    expectation = [1, 2, 3, 4, 1, 2, 3, 4, 1, 2]

    subject = Werkzeug::SequenceFactory.loop(1, 2, 3, 4)
    assert_equal(expectation, Array.new(10, &subject))

    subject = Werkzeug::SequenceFactory.loop(1, [2, 3], 4)
    assert_equal(expectation, Array.new(10, &subject))

    subject = Werkzeug::SequenceFactory.loop([1, [[2, 3], 4]])
    assert_equal(expectation, Array.new(10, &subject))
  end

  def test_ping_pong
    expectation = [1, 2, 3, 4, 3, 2, 1, 2, 3, 4]

    subject = Werkzeug::SequenceFactory.ping_pong(1, 2, 3, 4)
    assert_equal(expectation, Array.new(10, &subject))

    subject = Werkzeug::SequenceFactory.ping_pong(1, [2, 3], 4)
    assert_equal(expectation, Array.new(10, &subject))

    subject = Werkzeug::SequenceFactory.ping_pong([1, [[2, 3], 4]])
    assert_equal(expectation, Array.new(10, &subject))
  end

  def test_random
    expectation = [1, 2, 3, 4]

    subject = Werkzeug::SequenceFactory.random(1, 2, 3, 4)
    10.times{ assert_includes(expectation, subject.call) }

    subject = Werkzeug::SequenceFactory.random(1, [2, 3], 4)
    10.times{ assert_includes(expectation, subject.call) }

    subject = Werkzeug::SequenceFactory.random([1, [[2, 3], 4]])
    10.times{ assert_includes(expectation, subject.call) }
  end
end
