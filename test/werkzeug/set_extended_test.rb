require_relative '../test_helper'

class SetExtendedTest < Test
  TestItem = Struct.new(:id, :name)

  def each_sample_item
    return to_enum(__method__) unless block_given?
    yield(TestItem.new(:first, 'one'))
    yield(TestItem.new(:second, 'two'))
    yield(TestItem.new(:third, 'three'))
    yield(TestItem.new(:fourth, 'four'))
  end

  def sample_items
    each_sample_item.to_a.shuffle!
  end

  def more_items
    [TestItem.new(:fifth, 'five'), TestItem.new(:sixt, 'six')]
  end

  def sort_by_id(ary)
    ary.to_a.sort! { |a, b| a.__id__ <=> b.__id__ }
  end

  def assert_uniqueness(subject)
    assert_same(4, subject.size)
    subject.merge!(sample_items)
    assert_same(4, subject.size)

    assert(subject == each_sample_item)

    assert_same(6, subject.merge!(more_items).size)

    assert_equal(more_items, sort_by_id(subject - each_sample_item))
  end

  def test_uniqueness
    assert_uniqueness(
      Werkzeug::Set.new(each_sample_item, compare_by_identity: true, &:id)
    )
    assert_uniqueness(Werkzeug::Set.new(each_sample_item, &:name))
  end
end
