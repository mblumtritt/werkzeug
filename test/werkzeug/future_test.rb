require_relative '../test_helper'

class FutureTest < Test
  def test_arguments
    Werkzeug::Future.new(1, 2, arg1: 1, arg2: 2) do |*args|
      assert_equal([1, 2, {arg1: 1, arg2: 2}], args)
    end.wait
  end

  def test_entities
    result = BasicObject.new
    subject = Werkzeug::Future.new{ result }
    assert_same(subject, subject.wait)
    assert(subject.avail?)
    assert(subject.value?)
    refute(subject.error?)
    assert_same(result, subject.value)
  end

  def test_value
    result = BasicObject.new
    subject = Werkzeug::Future.new{ result }
    assert_same(result, subject.value)
    assert_same(result, subject.value) # re-read
    refute(subject.error?)
  end

  def test_error_handling
    subject = Werkzeug::Future.new{ raise('invalid by definition') }
    backtrace_top = nil
    begin
      subject.value
    rescue StandardError => ex
      backtrace_top = ex.backtrace[0]
    end
    assert(backtrace_top.index(__FILE__))
    assert_match(/in `block in test_error_handling'$/, backtrace_top)
    assert(subject.error?)
  end
end
