require_relative '../test_helper'

class SetTest < Test
  attr_reader :subject

  def setup
    @subject = Werkzeug::Set[1, 2, 3, 4, 4, 3, 2, 1]
  end

  def test_defaults
    subject = Werkzeug::Set.new
    assert_same(0, subject.size)
    assert_same(0, subject.count)
    assert(subject.empty?)
  end

  def test_entities
    assert_same(4, subject.size)
    assert_same(4, subject.count)
    assert_same(2, subject.count(&:odd?))
    refute(subject.empty?)
    assert_equal([1, 2, 3, 4], subject.items)
    assert_equal([1, 2, 3, 4], subject.to_a)
  end

  def test_freeze
    refute(subject.frozen?)
    assert_same(subject, subject.freeze)
    assert(subject.frozen?)
  end

  def test_clear
    refute(subject.empty?)
    assert_same(subject, subject.clear)
    assert(subject.empty?)
  end

  def test_add
    assert_same(42, subject.add(42))
    assert_same(5, subject.size)
    assert_same(42, subject.add(42))
    assert_same(5, subject.size)
    assert_same(subject, subject << 21 << 1 << 666 << 42)
    assert_same(7, subject.size)
  end

  def test_include
    assert(subject.include?(1))
    refute(subject.include?(42))
    assert(subject.member?(1))
    refute(subject.member?(42))
  end

  def test_delete
    assert_same(2, subject.delete(2))
    assert_nil(subject.delete(42))
    assert_same(3, subject.size)
  end

  def test_subtract
    enum = (1..21).lazy.select(&:odd?)
    assert_equal([1, 3], subject.substract(enum))
    assert_empty(subject.substract([1, 3, 42]))
  end

  def test_merge
    assert_instance_of(Werkzeug::Set, subject.merge([]))
    assert_equal([1, 2, 3, 4, 21, 42], subject.merge([21, 42]).to_a)

    enum = (1..21).lazy.select(&:odd?)
    assert_same(13, subject.merge(enum).size)
  end

  def test_merge!
    assert_same(subject, subject.merge!([42]))
    assert_same(5, subject.size)

    enum = (1..21).lazy.select(&:odd?)
    assert_same(14, subject.merge!(enum).size)
  end

  def test_compare
    assert(subject.superset?(1..3))
    assert(subject.superset?(1..4))
    refute(subject.superset?(1..6))

    assert(subject >= (1..3))
    assert(subject >= (1..4))
    refute(subject >= (1..6))
    assert(subject >= Werkzeug::Set[4, 3, 2, 1])

    assert(subject.proper_superset?(1..3))
    refute(subject.proper_superset?(1..4))

    assert(subject > (1..3))
    refute(subject > (1..4))
    assert(subject > Werkzeug::Set[3, 2, 1])

    assert(subject.subset?(1..10))
    assert(subject.subset?(1..4))
    refute(subject.subset?(1..2))

    assert(subject <= (1..10))
    assert(subject <= (1..4))
    refute(subject <= (1..2))
    assert(subject <= Werkzeug::Set[1, 2, 4, 3])

    assert(subject.proper_subset?(1..10))
    refute(subject.proper_subset?(1..4))
    refute(subject.proper_subset?(1..2))

    assert(subject < (1..10))
    refute(subject < (1..4))
    refute(subject < (1..2))
    assert(subject < Werkzeug::Set[5, 1, 2, 4, 3])

    assert(subject.intersect?([1, 2]))
    assert(subject.intersect?([1, 2, 4, 5, 6]))

    refute(subject.disjoint?([1, 2]))
    refute(subject.disjoint?([1, 2, 4, 5, 6]))
  end

  def test_operators
    assert_equal([1, 2, 3, 4, 5, 6, 7], subject.union([1, 2, 5, 6, 7]).to_a)
    assert_equal([1, 2, 3, 4, 5, 6, 7], (subject + (1..7)).to_a)

    assert_equal([1, 2], subject.difference([3, 4, 5, 6, 7]).to_a)
    assert_equal([1, 2], (subject - (3..7)).to_a)

    assert_equal([3, 4], subject.intersection(3..10).to_a)
    assert_equal([3, 4], (subject & (3..10)).to_a)

    assert_equal([5, 6, 7, 1], (subject ^ (2..7)).to_a)

    assert(subject == subject)
    assert(subject == [1, 2, 3, 4])
    assert(subject != subject.merge([5]))
  end
end
