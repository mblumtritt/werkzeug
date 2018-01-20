module Werkzeug
  module PrefixedCalls
    def call_all(prefix, *args)
      @__prefixed_methods ||= Hash.new do |h, prefix|
        prefix = prefix.to_s
        prefixes = [prefix, '__' + prefix, '_' + prefix]
        h[prefix.to_sym] = methods.select{ |name| name.to_s.start_with?(*prefixes) }.sort!
      end
      @__prefixed_methods[prefix.to_sym].each{ |name| send(name, *args) }
    end
  end
end
