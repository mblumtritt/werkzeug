require_relative '../test_helper'

class ContextTest < Test
  def test_defaults
    context = Werkzeug.context
    assert_respond_to(context, :size)
    assert_respond_to(context, :attr)
    assert_respond_to(context, :attr?)
    assert_respond_to(context, :to_h)
    assert_respond_to(context, :inspect)
    assert_same(0, context.size)
    assert_equal([], context.attr)
    assert_equal({}, context.to_h)
    assert_equal('#<DefaultContext>', context.inspect)
  end

  def test_attributes
    context = Werkzeug::Context.new

    refute_respond_to(context, :int)
    context.int = 42
    assert_respond_to(context, :int)

    context.val = nil
    assert_equal({ int: 42, val: nil }, context.to_h)
    assert_equal(
      "#<Context::#{context.__id__} int:42, val:nil>",
      context.inspect
    )

    i = 0
    context.define('block') { i += 1 }
    assert_same(1, context.block)
    assert_same(2, context.block)

    context.define(:sum) { |a, b| a + b }
    assert_same(11, context.sum(4, 7))

    assert_equal(%i[int val block sum], context.attr)
    assert(context.attr?(:int))

    refute(context.val?)
    context.val = 'yes'
    assert(context.val?)
    assert_equal('yes', context.delete(:val))
    refute(context.val?)
    refute(context.attr?(:val))

    assert_raises(NoMethodError) { context.no_val }
  end
end
