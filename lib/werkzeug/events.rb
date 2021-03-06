# frozen_string_literal: true

require_relative 'error'
require_relative 'delegate'

module Werkzeug
  class Events
    extend Delegate

    def self.default
      @default ||= new
    end

    delegate :empty?, :size, to: :@root

    def initialize
      reset!
    end

    def reset!
      @root = Node.new
    end
    alias clear! reset!

    def call(event, opts = {})
      @root.fire(split(event), opts.merge(event: event.to_s).freeze)
    end
    alias fire call

    def on(*events, &consumer)
      Error::NoArgument.raise! if events.empty?
      events = events.map! { |event| split(event) }
      Error::NoBlockGiven.raise! unless consumer
      id = consumer.__id__
      events.each { |parts| @root.insert(parts, id, consumer) }
      id
    end

    def register(object, **events)
      Error::NoArgument.raise! if object.nil?
      Error::NoArgument.raise! if events.empty?
      transform(object, events).transform_values! do |parts, id, method|
        @root.insert(parts, id, method)
        id
      end
    end

    def remove(*ids)
      @root.remove(ids.uniq)
      self
    end

    def remove_all(event)
      @root.remove_all(split(event))
      self
    end

    private

    def transform(object, events)
      ret = {}
      events.each_pair do |name, event|
        method = as_method(object, name)
        ret[name] = [split(event), method.__id__, method]
      end
      ret
    end

    def as_method(object, name)
      method = object.method(name)
      unless method.arity == 1 || method.arity < 0
        Error::InvalidMethod.raise!(name)
      end
      method
    rescue NameError
      Error::MethodExpected.raise!(name)
    end

    def split(event)
      parts = event.to_s.split('.')
      if parts.empty? || parts.any?(&:empty?)
        Error::InvalidEventName.raise!(event)
      end
      parts
    end

    class Node
      def initialize
        @nodes = Hash.new { |h, k| h[k] = Node.new }
        @consumers = {}.compare_by_identity
      end

      def empty?
        size.zero?
      end

      def size
        sum = @consumers.size
        @nodes.each_value { |node| sum += node.size }
        sum
      end

      def insert(parts, id, consumer)
        if parts.empty?
          @consumers[id] = consumer
        else
          @nodes[parts.shift].insert(parts, id, consumer)
        end
      end

      def remove(ids)
        ids.each { |id| @consumers.delete(id) }
        @nodes.each_value { |node| node.remove(ids) }
      end

      def remove_all(parts)
        part = parts.shift
        parts.empty? ? @nodes.delete(part) : @nodes[part].remove_all(parts)
      end

      def fire(parts, opts)
        if parts.empty?
          @consumers.values.each { |c| c.call(**opts) }
        else
          part = parts.shift
          @nodes['*'].fire(Array.new(parts), opts) if @nodes.key?('*')
          @nodes[part].fire(parts, opts) if @nodes.key?(part)
        end
      end
    end

    private_constant(:Node)
  end
end
