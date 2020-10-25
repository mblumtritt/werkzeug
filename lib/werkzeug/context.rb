# frozen_string_literal: true

require_relative 'delegate'

module Werkzeug
  class Context < BasicObject
    extend Delegate

    def self.default
      @default ||= new(:DefaultContext)
    end

    delegate :size, :delete, to: :@attr

    def initialize(name = nil)
      @attr = {}
      @name = name ? name.dup : "Context::#{__id__}"
    end

    def define(attribute, &block)
      @attr[attribute.to_s.to_sym] = block
    end

    def attr
      @attr.keys
    end

    def attr?(att)
      @attr.key?(att)
    end

    def to_h
      ::Hash[@attr]
    end

    def inspect
      details = to_h.map { |k, v| "#{k}:#{v.inspect}" }.join(', ')
      details.empty? ? "#<#{@name}>" : "#<#{@name} #{details}>"
    end

    def respond_to?(name, _ = false)
      BASE_METHODS.index(name) || attr?(name) ||
        (name.end_with?('=', '?') && attr?(name.to_s.chop.to_sym))
    end

    def method_missing(name, *args, &block)
      if @attr.key?(name)
        ret = @attr[name]
        ret = ret.call(*args) if defined?(ret.call)
        return block ? block.call(ret) : ret
      end
      return @attr[name.to_s.chop.to_sym] = args[0] if name.end_with?('=')
      super unless name.end_with?('?')
      ret = @attr[name.to_s.chop.to_sym]
      ret = ret.call(*args) if defined?(ret.call)
      ret = ret ? true : false
      block ? block.call(ret) : ret
    end

    BASE_METHODS = %i[
      size
      delete
      attr
      attr?
      to_h
      inspect
      respond_to?
      method_missing
    ].freeze

    private_constant(:BASE_METHODS)
  end
end
