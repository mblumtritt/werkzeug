require_relative 'error'

module Werkzeug
  module ToolFunctions
    def enum(*args, start: 0)
      names = tf_constant_names_of(args)
      ret = Module.new
      names.each_with_index { |name, i| ret.const_set(name, start + i) }
      ret
    end

    def consts(**opts)
      Error::NoArgument.raise! if opts.empty?
      ret = Module.new
      opts.each_pair { |name, value| ret.const_set(name, value) }
      ret
    end

    def bits(*args)
      names = tf_constant_names_of(args)
      ret = Module.new
      names.each_with_index { |name, i| ret.const_set(name, 1 << i) }
      ret
    end

    private

    def tf_constant_names_of(args)
      Error::NoArgument.raise! if args.empty?
      names = args.map(&:to_sym)
      names.uniq!
      return names if names.size == args.size
      Error::DoublicateArgumentNames.raise!(args.inspect)
    end
  end

  extend ToolFunctions
end
