require_relative '../test_helper'

class HashInspectionTest < Test
  class Sample
    include Werkzeug::HashInspection

    def to_h
      { foo: 42, items: ::Array.new(3, &:itself) }
    end
  end

  class BasicSample < BasicObject
    include ::Werkzeug::HashInspection

    def to_h
      { foo: 42, items: ::Array.new(3, &:itself) }
    end
  end

  class BadSample
    include Werkzeug::HashInspection
  end

  def test_inspect
    sample = Sample.new
    assert_equal(
      "#<HashInspectionTest::Sample::#{sample.__id__} foo:42, items:[0, 1, 2]>",
      sample.inspect
    )
    basic_sample = BasicSample.new
    assert_equal(
      "#<<#{basic_sample.__id__} foo:42, items:[0, 1, 2]>>",
      basic_sample.inspect
    )
  end

  def test_fallback
    bad_sample = BadSample.new
    assert_match(
      /\A#<HashInspectionTest::BadSample:0x[[:xdigit:]]*>\z/,
      bad_sample.inspect
    )
  end
end
