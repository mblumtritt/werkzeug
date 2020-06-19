module Werkzeug
  module PrefixedCalls
    def call_all(prefix, *args)
      prefix = prefix.to_s
      prefixes = [prefix, '__' + prefix, '_' + prefix]
      methods.select { |name| name.to_s.start_with?(*prefixes) }.sort!
        .each { |name| send(name, *args) }
      self
    end
  end
end
