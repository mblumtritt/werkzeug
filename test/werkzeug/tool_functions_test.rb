require_relative '../test_helper'

class ToolFunctionsTest < Test
  include Werkzeug::ToolFunctions

  def test_enum
    result = enum(:Apple, 'Orange', :Pate)
    assert_kind_of(Module, result)

    assert_equal(%i[Apple Orange Pate], result.constants.sort)
    assert_same(0, result::Apple)
    assert_same(1, result::Orange)
    assert_same(2, result::Pate)

    result = enum(:Apple, :Orange, :Pate, start: 10)
    assert_same(10, result::Apple)
    assert_same(11, result::Orange)
    assert_same(12, result::Pate)
  end

  def test_enum_errors
    assert_raises(Werkzeug::Error::NoArgument) { enum }
    assert_raises(Werkzeug::Error::NoArgument) { enum(start: 666) }
    assert_raises(Werkzeug::Error::DoublicateArgumentNames) do
      enum(:Apple, :Orange, :Plum, :Apple)
    end
    assert_raises(NoMethodError) { enum(1, 2, 3) }
  end

  def test_consts
    result = consts(Apple: 1, Orange: 4, Pate: 10)
    assert_kind_of(Module, result)

    assert_equal(%i[Apple Orange Pate], result.constants.sort)
    assert_same(1, result::Apple)
    assert_same(4, result::Orange)
    assert_same(10, result::Pate)

    result = consts(Apple: 1, Orange: 1, Pate: 1)
    assert_same(1, result::Apple)
    assert_same(1, result::Orange)
    assert_same(1, result::Pate)
  end

  def test_consts_errors
    assert_raises(Werkzeug::Error::NoArgument) { consts }
    assert_raises(ArgumentError) { consts(1, 2, 3) }
    assert_raises(NameError) { consts(apple: 1) }
  end

  def test_bits
    result = bits(:Apple, 'Orange', :Pate)
    assert_kind_of(Module, result)
    assert_equal(%i[Apple Orange Pate], result.constants.sort)
    assert_same(1, result::Apple)
    assert_same(2, result::Orange)
    assert_same(4, result::Pate)
  end

  def test_bits_errors
    assert_raises(Werkzeug::Error::NoArgument) { bits }
    assert_raises(Werkzeug::Error::DoublicateArgumentNames) do
      bits(:Apple, :Orange, :Plum, :Apple)
    end
    assert_raises(NoMethodError) { bits(1, 2, 3) }
  end
end
