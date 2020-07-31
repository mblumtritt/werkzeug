require_relative '../test_helper'

class DelegateTest < Test
  class SampleClass
    extend Werkzeug::Delegate

    delegate :size, :[]=, to: :@ary
    delegate :empty?, to: :@ary, prefix: 'is'

    attr_reader :ary

    def initialize
      @ary = []
    end
  end

  def test_delegate
    subject = SampleClass.new

    assert_same(42, subject[100] = 42)
    assert_same(42, subject.ary[100])
    assert_same(101, subject.size)
    refute(subject.is_empty?)
  end
end
