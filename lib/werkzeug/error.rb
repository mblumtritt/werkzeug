# frozen_string_literal: true

require_relative 'custom_exceptions'

module Werkzeug
  class Error < ArgumentError
    extend CustomExceptions
    NoBlockGiven = create_exception('block expected')
    NoArgument = create_exception('too few arguments')
    ArgumentCount = create_exception(
      'wrong number of arguments (given %s, expected %s)'
    )
    InvalidMethod = create_exception('no such method - #%s')
    MethodExpected = create_exception('missing method for argument - #%s')
    DoublicateArgumentNames = create_exception(
      'arguments contain duplicate names - #%s'
    )
    InvalidEventName = create_exception('invaid event name - %s')
  end
end
