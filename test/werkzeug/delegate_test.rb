require_relative '../test_helper'

class DelegateTest < Test
  class SampleClass
    extend Werkzeug::Delegate

    delegate :size, :[]=, to: :@ary
    delegate :empty?, to: :@ary, prefix: 'is'
    delegate :to_a, to: :@ary, scope: :private
    delegate :at, to: :@ary, scope: :protected

    attr_reader :ary

    def initialize
      @ary = []
    end
  end

  def setup
    @subject = SampleClass.new
  end

  attr_reader :subject

  def test_delegate
    assert_same(42, subject[100] = 42)
    assert_same(42, subject.ary[100])
    assert_same(101, subject.size)
    refute(subject.is_empty?)
  end

  def test_scoping
    refute_includes(SampleClass.public_instance_methods, :to_a)
    refute_includes(SampleClass.public_instance_methods, :at)

    assert_includes(SampleClass.private_instance_methods, :to_a)
    assert_includes(SampleClass.protected_instance_methods, :at)
  end
end
