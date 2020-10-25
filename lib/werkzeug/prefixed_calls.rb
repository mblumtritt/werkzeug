module Werkzeug
  module PrefixedCalls
    def call_all(prefix, *args, **opts, &block)
      prefix = prefix.to_s
      prefixes = [prefix, '__' + prefix, '_' + prefix]
      methods.select { |name| name.to_s.start_with?(*prefixes) }.sort!
        .each { |name| send(name, *args, **opts, &block) }
      self
    end
  end
end
