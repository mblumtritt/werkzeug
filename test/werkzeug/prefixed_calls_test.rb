require_relative '../test_helper'

class PrefixedCallsTest < Test
  class TestClass
    include Werkzeug::PrefixedCalls

    attr_reader :called

    def initialize
      @called = []
    end

    alias _methods methods
    def methods
      @called << __method__
      _methods
    end

    def setup
      @called << __method__
    end

    def setup_foo
      @called << __method__
    end

    def _setup
      @called << __method__
    end

    def _setup_foo
      @called << __method__
    end

    def args(*args, **opts, &block)
      @called << args << opts << block
    end
  end

  def setup
    @subject = TestClass.new
  end

  def test_call_all
    expected = %i[methods _setup _setup_foo setup setup_foo]

    @subject.call_all(:setup)
    assert_equal(expected, @subject.called)
  end

  def test_call_all_strings
    expected = %i[methods _setup _setup_foo setup setup_foo]

    @subject.call_all('setup')
    assert_equal(expected, @subject.called)
  end

  def test_not_existing
    expected = %i[methods]

    @subject.call_all(:update)
    assert_equal(expected, @subject.called)
  end

  def test_forward_arguments
    block = -> {  }
    expected = [:methods, [1, 2, 3], { a: 1, b: 2 }, block]

    @subject.call_all(:args, 1, 2, 3, a: 1, b: 2, &block)
    assert_equal(expected, @subject.called)
  end
end
