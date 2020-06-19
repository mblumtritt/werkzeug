require_relative '../test_helper'

class FutureTest < Test
  def test_arguments
    arguments =
      Werkzeug::Future.new(1, 2, arg1: 1, arg2: 2) { |*args| args }.value
    assert_equal([1, 2, { arg1: 1, arg2: 2 }], arguments)
  end

  def test_entities
    result = BasicObject.new
    subject = Werkzeug::Future.new { result }
    assert_same(subject, subject.wait)
    assert(subject.avail?)
    assert(subject.value?)
    refute(subject.error?)
    assert_same(result, subject.value)
  end

  def test_value
    result = BasicObject.new
    subject = Werkzeug::Future.new { result }
    assert_same(result, subject.value)
    refute(subject.error?)
    assert_same(result, subject.value) # re-read
  end

  def test_error_handling
    subject = Werkzeug::Future.new { raise('invalid by definition') }
    execption = assert_raises(StandardError) { subject.value }
    backtrace_top = execption.backtrace[0]
    assert(backtrace_top.index(__FILE__))
    assert_match(/in `block in test_error_handling'$/, backtrace_top)
    assert(subject.error?)
    refute(subject.value?)
    assert_raises(StandardError) { subject.value } # re-read
  end
end
