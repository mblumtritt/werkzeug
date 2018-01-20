module Werkzeug
  module PrefixedCalls
    def call_all(prefix, *args)
      @__prefixed_methods ||= Hash.new do |h, prefx|
        prefx = prefx.to_s
        prefixes = [prefx, '__' + prefx, '_' + prefx]
        h[prefix.to_sym] = methods.select{ |name| name.to_s.start_with?(*prefixes) }.sort!
      end
      @__prefixed_methods[prefix.to_sym].each{ |name| send(name, *args) }
    end
  end
end
