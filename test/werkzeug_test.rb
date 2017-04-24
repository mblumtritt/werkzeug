require_relative './test_helper'

class WerkzeugTest < Test
  def test_configure
    assert_same(Werkzeug::Config, Werkzeug.configure)
    Werkzeug.configure do |arg|
      assert_same(Werkzeug::Config, arg)
    end
  end

  def test_data_file
    assert_same(Werkzeug::DataFile.default, Werkzeug.data_file)
  end

  def test_events
    assert_same(Werkzeug::Events.default, Werkzeug.events)
  end

  def test_future
    assert_same(Werkzeug::Future, Werkzeug.future{}.class)
  end

  def test_host_os
    assert_same(Werkzeug::HostOS.type, Werkzeug.host_os)
  end

  def test_temp_dir
    assert_same(Werkzeug::HostOS.temp_dir, Werkzeug.temp_dir)
  end

  def test_thread_pool
    assert_same(Werkzeug::ThreadPool.default, Werkzeug.thread_pool)
  end
end
