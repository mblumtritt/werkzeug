require_relative 'config'

module Werkzeug
  module DataFile
    RE_END = /^__END__$\s*/

    def self.read(file_name = nil)
      parse(File.read(file_name || caller_locations[0].path).split(RE_END, 2)[-1])
    end

    def self.parse(lines)
      Error::MethodExpected.raise!('#each_line') unless defined?(lines.each_line)
      ret, name, content = {}, :default, []
      lines.each_line do |line|
        next content << line unless line.start_with?('@@ '.freeze)
        ret[name] = content.join
        name, content = line.chomp[3..-1].to_sym, []
      end
      ret[name] = content.join
      ret
    end

    def self.default
      @default ||= parse(DATA).freeze
    end

    def self.names
      default.keys
    end

    def self.[](name)
      default[name]
    end
  end
end
