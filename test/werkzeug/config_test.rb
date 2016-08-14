require_relative '../test_helper'

class ConfigTest < Test
  def test_thread_count
    assert_same(
      Werkzeug::Config.suggested_thread_count,
      Werkzeug::Config.default_thread_count
    )
    Werkzeug::Config.default_thread_count = 42
    assert_same(42, Werkzeug::Config.default_thread_count)
    Werkzeug::Config.default_thread_count = nil
    assert_same(
      Werkzeug::Config.suggested_thread_count,
      Werkzeug::Config.default_thread_count
    )
  end
end
