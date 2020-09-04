# frozen_string_literal: true

require_relative 'hash_inspection'

module Werkzeug
  module StaticClassMethods
    def attriibutes(*names)
      names = names.freeze
      self.class_eval { names.each { |name| attr_reader(name) } }
      define_method(:__attributes) { names }
      private(:__attributes)
    end
  end

  module Static
    def self.new(*args, &block)
      klass =
        Class.new(args.first.is_a?(Class) ? args.shift : Object) do
          include(Static)
          attriibutes(*args)
        end
      klass.class_eval(&block) if block
      klass
    end

    def self.included(base)
      base.extend(StaticClassMethods)
    end

    include HashInspection

    def initialize(attributes = {})
      super()
      __attributes.each do |name|
        value = attributes.key?(name) ? attributes[name] : nil
        instance_variable_set("@#{name}", value)
      end
    end

    def attr?(attribute)
      __attributes.index(attribute)
    end

    def fetch(attribute, default = nil)
      return send(attribute) if __attributes.index(attribute)
      return yield(self, attribute) if block_given?
      default
    end

    def [](attribute)
      __attributes.index(attribute) ? send(attribute) : nil
    end

    def each_pair
      return to_enum(__method__) unless block_given?
      __attributes.each { |name| yield(name, send(name)) }
    end

    def update(new_attributes)
      self.class.new(
        __attributes.each_with_object({}) do |name, ret|
          ret[name] =
            new_attributes.key?(name) ? new_attributes[name] : send(name)
        end
      )
    end

    def ==(other)
      __attributes.all? do |name|
        other.respond_to?(name) && send(name) == other.send(name)
      end
    end

    def eql?(other)
      self.class == other.class && self == other
    end

    def hash
      (to_a << self.class).hash
    end

    def to_a(*only)
      return __attributes.map { |attribute| send(attribute) } if only.empty?
      attributes = __attributes
      only.map { |name| attributes.index(name) ? send(name) : nil }
    end

    def to_h(*only)
      if only.empty?
        __attributes.each_with_object({}) { |name, ret| ret[name] = send(name) }
      else
        attributes = __attributes
        only.each_with_object({}) do |name, ret|
          ret[name] = send(name) if attributes.index(name)
        end
      end
    end

    def to_s
      inspect
    end
  end
end
