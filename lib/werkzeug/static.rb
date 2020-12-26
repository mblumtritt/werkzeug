# frozen_string_literal: true

require_relative 'hash_inspection'

module Werkzeug
  module StaticClassMethods
    def attributes(*names, **mapped_names)
      attr_map = Hash[names.map { |name| [name, name] }].merge!(mapped_names)
      class_eval { attr_map.each_key { |name| attr_reader(name) } }
      if private_method_defined?(:__attributes)
        new.__send__(:__attributes).merge!(attr_map)
      else
        private define_method(:__attributes) { attr_map }
      end
    end
    alias attribute attributes
  end

  module Static
    def self.new(*args, **mapped_names, &block)
      ret =
        Class.new(args.first.is_a?(Class) ? args.shift : Object) do
          include(Static)
          attributes(*args, **mapped_names)
        end
      ret.class_eval(&block) if block
      ret
    end

    def self.included(base)
      base.extend(StaticClassMethods)
    end

    include HashInspection

    def initialize(attributes = {})
      super()
      __attributes.each_pair do |name, sname|
        value = attributes.key?(sname) ? attributes[sname] : nil
        instance_variable_set("@#{name}", value)
      end
      @__hash = nil
    end

    def attr?(attribute)
      __attributes.key?(attribute)
    end

    def fetch(attribute, default = nil)
      return __send__(attribute) if __attributes.key?(attribute)
      return yield(self, attribute) if block_given?
      default
    end

    def [](attribute)
      __attributes.key?(attribute) ? __send__(attribute) : nil
    end

    def each_pair
      return to_enum(__method__) unless block_given?
      __attributes.each_key { |name| yield(name, __send__(name)) }
    end

    def update(new_attributes)
      args = {}
      __attributes.each_pair do |name, sname|
        args[sname] =
          new_attributes.key?(name) ? new_attributes[name] : __send__(name)
      end
      self.class.new(args)
    end

    def ==(other)
      __attributes.keys.all? do |name|
        other.respond_to?(name) && __send__(name) == other.__send__(name)
      end
    end

    def eql?(other)
      self.class == other.class && self == other
    end

    def hash
      @__hash ||= (to_a << self.class).hash
    end

    def to_a(*only)
      return __attributes.keys.map! { |name| __send__(name) } if only.empty?
      attributes = __attributes
      only.map { |name| attributes.key?(name) ? __send__(name) : nil }
    end

    def to_h(*only)
      if only.empty?
        __attributes
          .keys
          .each_with_object({}) { |name, ret| ret[name] = __send__(name) }
      else
        attributes = __attributes
        only.each_with_object({}) do |name, ret|
          ret[name] = __send__(name) if attributes.key?(name)
        end
      end
    end

    alias to_s inspect
  end
end
