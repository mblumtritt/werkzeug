require_relative '../test_helper'

class CustomExceptionTest < Test
  def test_standard
    mod =
      Module.new do
        extend Werkzeug::CustomExceptions
        def_exception :Error, 'error - %s'
      end
    assert(mod::Error < StandardError)
    assert_raises_message(mod::Error, 'error - 42') { mod::Error.raise!(42) }
  end

  def test_with_parent
    mod =
      Module.new do
        extend Werkzeug::CustomExceptions
        def_exception :ArgErr, ArgumentError, 'error - %s'
      end
    assert(mod::ArgErr < ArgumentError)
    assert_raises_message(mod::ArgErr, 'error - 42') { mod::ArgErr.raise!(42) }
  end

  def test_class_embedding
    klass =
      Class.new(RuntimeError) do
        extend Werkzeug::CustomExceptions
        def_exception :Error, 'error - %s'
      end
    assert_raises_message(klass, 'error - 42') { klass::Error.raise!(42) }
  end

  def test_wrong_parent
    assert_raises(TypeError) do
      Module.new do
        extend Werkzeug::CustomExceptions
        def_exception :Error, Object, 'Oh oh'
      end
    end
  end
end
