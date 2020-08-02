require_relative '../test_helper'

class StaticTest < Test
  SampleClass =
    Werkzeug::Static.new(:a, :b) do
      def c
        :c
      end
    end

  def test_defaults
    subject = SampleClass.new

    assert_nil(subject.a)
    assert_nil(subject.b)
    assert_nil(subject[:a])
    assert_nil(subject[:b])
    assert_same(:c, subject.c)
    assert(subject.attr?(:a))
    assert(subject.attr?(:b))
    assert_instance_of(Enumerator, subject.each_pair)
    assert_equal([[:a, nil], [:b, nil]], subject.each_pair.to_a)

    another = SampleClass.new
    assert(subject == another)
    assert(subject.eql?(another))
    assert_same(another.hash, subject.hash)

    assert_equal([nil, nil], subject.to_a)
    assert_equal({ a: nil, b: nil }, subject.to_h)
  end

  def test_attributes
    subject = SampleClass.new(a: 42, b: :some)

    assert_same(42, subject.a)
    assert_same(:some, subject.b)
    assert_same(42, subject[:a])
    assert_same(:some, subject[:b])
    assert_same(:c, subject.c)
    assert(subject.attr?(:a))
    assert(subject.attr?(:b))
    assert_instance_of(Enumerator, subject.each_pair)
    assert_equal([[:a, 42], %i[b some]], subject.each_pair.to_a)

    another = SampleClass.new(a: 42, b: :some)
    assert(subject == another)
    assert(subject.eql?(another))
    assert_same(another.hash, subject.hash)

    assert_equal([42, :some], subject.to_a)
    assert_equal({ a: 42, b: :some }, subject.to_h)
  end

  def test_update
    subject = SampleClass.new(a: 21, b: :b)

    assert_same(21, subject.a)
    assert_same(:b, subject.b)

    updated = subject.update(a: :a, b: nil)
    assert_same(:a, updated.a)
    assert_nil(updated.b)
  end
end
