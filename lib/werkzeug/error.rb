require_relative 'custom_exceptions'

module Werkzeug
  class Error < ArgumentError
    extend CustomExceptions
    NoBlockGiven = create_exception('block expected')
    NoArgument = create_exception('too few arguments')
    ArgumentCount = create_exception('wrong number of arguments (given %s, expected %s)')
    MethodExpected = create_exception('argument does not implement %s')
  end
end
