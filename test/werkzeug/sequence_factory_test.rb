require_relative '../test_helper'

class SequenceFactoryTest < Test
  def test_loop
    subject = Werkzeug::SequenceFactory.loop('H', 'e', 'l', 'l', 'o')
    assert_equal('HelloHello', Array.new(10, &subject).join)
  end

  def test_loop_dummy
    subject = Werkzeug::SequenceFactory.loop
    assert(Array.new(10, &subject).all?(&:nil?))
  end

  def test_ping_pong
    subject = Werkzeug::SequenceFactory.ping_pong('H', 'e', 'l', 'l', 'o')
    assert_equal('HellolleHell', Array.new(12, &subject).join)
  end

  def test_ping_pong_dummy
    subject = Werkzeug::SequenceFactory.ping_pong
    assert(Array.new(10, &subject).all?(&:nil?))
  end

  def test_random
    elements = %w[T e s t].freeze
    subject = Werkzeug::SequenceFactory.random(*elements)
    10.times { assert_includes(elements, subject.call) }
  end

  def test_random_dummy
    subject = Werkzeug::SequenceFactory.random
    assert(Array.new(10, &subject).all?(&:nil?))
  end

  def test_linear_detect_up
    expectation = [1, 2, 3, 4, 1, 2, 3, 4, 1, 2]
    subject = Werkzeug::SequenceFactory.linear(1, 4)
    assert_equal(expectation, Array.new(10, &subject))
  end

  def test_linear_detect_up_delta
    expectation = [1, 3, 5, 7, 1, 3, 5, 7, 1, 3]
    subject = Werkzeug::SequenceFactory.linear(1, 8, -2)
    assert_equal(expectation, Array.new(10, &subject))
  end

  def test_linear_detect_down
    expectation = [4, 3, 2, 1, 4, 3, 2, 1, 4, 3]
    subject = Werkzeug::SequenceFactory.linear(4, 1)
    assert_equal(expectation, Array.new(10, &subject))
  end

  def test_linear_detect_down_delta
    expectation = [8, 6, 4, 2, 8, 6, 4, 2, 8, 6]
    subject = Werkzeug::SequenceFactory.linear(8, 1, 2)
    assert_equal(expectation, Array.new(10, &subject))
  end

  def test_linear_error
    assert_raises_message(ArgumentError, '(given 1, expected 2..3)') do
      Werkzeug::SequenceFactory.linear(1)
    end
    assert_raises_message(ArgumentError, '(given 4, expected 2..3)') do
      Werkzeug::SequenceFactory.linear(1, 2, 3, 4)
    end
  end

  def test_linear_up_int
    expectation = [1, 2, 3, 4, 1, 2, 3, 4, 1, 2]
    subject = Werkzeug::SequenceFactory.linear.up(1, 4, 1)

    assert_equal(expectation, Array.new(10, &subject))
  end

  def test_linear_up_float
    expectation = [1, 1.25, 1.5, 1.75, 2, 1, 1.25, 1.5]
    subject = Werkzeug::SequenceFactory.linear.up(1, 2, 0.25)

    assert_equal(expectation, Array.new(8, &subject))
  end

  def test_linear_up_dummy
    subject = Werkzeug::SequenceFactory.linear.up(1, 1.0, 0.25)
    assert_equal(Array.new(8, 1), Array.new(8, &subject))
  end

  def test_linear_down_int
    expectation = [4, 3, 2, 1, 4, 3, 2, 1, 4, 3]
    subject = Werkzeug::SequenceFactory.linear.down(4, 1, 1)
    assert_equal(expectation, Array.new(10, &subject))
  end

  def test_linear_down_float
    expectation = [2, 1.75, 1.5, 1.25, 1.0, 2, 1.75, 1.5]
    subject = Werkzeug::SequenceFactory.linear.down(2, 1, 0.25)
    assert_equal(expectation, Array.new(8, &subject))
  end

  def test_linear_down_dummy
    subject = Werkzeug::SequenceFactory.linear.down(1, 1, 0.25)
    assert_equal(Array.new(8, 1), Array.new(8, &subject))
  end

  def test_linear_ping_pong_int
    expectation = [1, 2, 3, 4, 3, 2, 1, 2, 3, 4]
    subject = Werkzeug::SequenceFactory.linear.ping_pong(1, 4, 1)
    assert_equal(expectation, Array.new(10, &subject))
  end

  def test_linear_ping_pong_float
    expectation = [1, 1.25, 1.5, 1.75, 2, 1.75, 1.5, 1.25, 1]
    subject = Werkzeug::SequenceFactory.linear.ping_pong(1, 2, 0.25)
    assert_equal(expectation, Array.new(9, &subject))
  end

  def test_linear_ping_pong_dummy
    subject = Werkzeug::SequenceFactory.linear.ping_pong(1, 1.0, 0.25)
    assert_equal(Array.new(8, 1), Array.new(8, &subject))
  end
end
