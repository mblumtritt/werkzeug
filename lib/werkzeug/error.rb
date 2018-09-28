# frozen_string_literal: true

require_relative 'custom_exceptions'

module Werkzeug
  class Error < ArgumentError
    extend CustomExceptions
    NoBlockGiven = create_exception('block expected')
    NoArgument = create_exception('too few arguments')
    MethodExpected = create_exception('missing method for argument - #%s')
    ArgumentCount = create_exception(
      'wrong number of arguments (given %s, expected %s)'
    )
    DoublicateArgumentNames = create_exception(
      'arguments contain duplicate names - #%s'
    )
  end
end
