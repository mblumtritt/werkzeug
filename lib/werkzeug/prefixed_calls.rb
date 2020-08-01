module Werkzeug
  module PrefixedCalls
    def call_all(prefix, *args, &block)
      prefix = prefix.to_s
      prefixes = [prefix, '__' + prefix, '_' + prefix]
      methods.select { |name| name.to_s.start_with?(*prefixes) }.sort!
        .each { |name| send(name, *args, &block) }
      self
    end
  end
end
