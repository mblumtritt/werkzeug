require_relative 'error'

module Werkzeug
  class Set
    def self.[](*args, compare_by_identity: false, &key_gen_proc)
      new(
        args.empty? ? nil : args,
        compare_by_identity: compare_by_identity,
        &key_gen_proc
      )
    end

    include Enumerable

    def initialize(enum = nil, compare_by_identity: false, &key_gen_proc)
      @items = {}
      if key_gen_proc
        @as_key = key_gen_proc
      else
        @as_key = :__id__.to_proc
        compare_by_identity = true
      end
      @items.compare_by_identity if compare_by_identity
      merge!(enum) if enum
    end

    def initialize_dup(obj)
      super
      @items = obj.instance_variable_get(:@items).dup
    end

    def initialize_clone(obj)
      super
      @items = obj.instance_variable_get(:@items).clone
    end

    def freeze
      @items.freeze
      super
    end

    def size
      @items.size
    end

    def count(&block)
      block ? super : @items.size
    end

    def empty?
      @items.empty?
    end

    def clear
      @items.clear
      self
    end

    def each(&block)
      @items.each_value(&block)
    end

    def items
      @items.values
    end
    alias to_a items

    def add(obj)
      @items[@as_key[obj]] = obj
    end

    def <<(obj)
      add(obj)
      self
    end

    def include?(obj)
      @items.key?(@as_key[obj])
    end
    alias member? include?

    def delete(obj)
      @items.delete(@as_key[obj])
    end

    def delete?(obj)
      key = @as_key[obj]
      return false unless @items.key?(key)
      @items.delete(key)
      true
    end

    def substract(enum)
      ret = []
      enum.each { |obj| ret << obj if delete(obj) }
      ret
    end

    def merge(enum)
      dup.merge!(enum)
    end

    def merge!(enum)
      enum.each { |obj| add(obj) }
      self
    end

    def superset?(enum)
      set = as_set(enum)
      size >= set.size && set.all? { |obj| include?(obj) }
    end
    alias >= superset?

    def proper_superset?(enum)
      set = as_set(enum)
      size > set.size && set.all? { |obj| include?(obj) }
    end
    alias > proper_superset?

    def subset?(enum)
      set = as_set(enum)
      size <= set.size && all? { |obj| set.include?(obj) }
    end
    alias <= subset?

    def proper_subset?(enum)
      set = as_set(enum)
      size < set.size && all? { |obj| set.include?(obj) }
    end
    alias < proper_subset?

    def intersect?(enum)
      set = as_set(enum)
      if size < set.size
        any? { |obj| set.include?(obj) }
      else
        set.any? { |obj| include?(obj) }
      end
    end

    def disjoint?(set)
      !intersect?(set)
    end

    def union(enum)
      dup.merge(enum)
    end
    alias + union
    alias | union

    def difference(enum)
      ret = dup
      ret.substract(enum)
      ret
    end
    alias - difference

    def intersection(enum)
      ret = create_with(nil)
      enum.each { |obj| ret.add(obj) if include?(obj) }
      ret
    end
    alias & intersection

    def ^(enum)
      ret = create_with(enum)
      each { |obj| ret.add(obj) unless ret.delete?(obj) }
      ret
    end

    def ==(other)
      self.equal?(other) ? true : to_a == as_ary(other)
    end

    private

    def as_ary(enum)
      enum.respond_to?(:to_a) ? enum.to_a : enum.each.to_a
    end

    def as_set(enum)
      enum.is_a?(Set) ? enum : create_with(enum)
    end

    def create_with(enum)
      self.class.new(
        enum,
        compare_by_identity: @items.compare_by_identity?,
        &@as_key
      )
    end
  end
end
