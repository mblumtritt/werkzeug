require_relative '../test_helper'

class StaticTest < Test
  SampleClass =
    Werkzeug::Static.new(:a, b: 'd') do
      def c
        :c
      end
    end

  class ExtendedSampleClass
    include(Werkzeug::Static)

    attributes :a, :b
    attribute c: :d
    attribute d: :e
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
    subject = SampleClass.new(:a => 42, 'd' => :some)

    assert_same(42, subject.a)
    assert_same(:some, subject.b)
    assert_same(42, subject[:a])
    assert_same(:some, subject[:b])
    assert_same(:c, subject.c)
    assert(subject.attr?(:a))
    assert(subject.attr?(:b))
    assert_instance_of(Enumerator, subject.each_pair)
    assert_equal([[:a, 42], %i[b some]], subject.each_pair.to_a)

    another = SampleClass.new(:a => 42, 'd' => :some)
    assert(subject == another)
    assert(subject.eql?(another))
    assert_same(another.hash, subject.hash)

    assert_equal([42, :some], subject.to_a)
    assert_equal({ a: 42, b: :some }, subject.to_h)
  end

  def test_update
    subject = SampleClass.new(:a => 21, 'd' => :b)

    assert_same(21, subject.a)
    assert_same(:b, subject.b)

    updated = subject.update(a: :a, b: nil)
    assert_same(:a, updated.a)
    assert_nil(updated.b)
  end

  def test_attribute_extension
    subject = ExtendedSampleClass.new(a: 1, b: 2, d: 3, e: 4)

    assert_same(1, subject.a)
    assert_same(2, subject.b)
    assert_same(3, subject.c)
    assert_same(4, subject.d)
  end

  def test_on_the_fly
    subject = Werkzeug.create_static(:a, b: 'd').new(:a => 42, 'd' => :some)

    assert_same(42, subject.a)
    assert_same(:some, subject.b)
  end
end
