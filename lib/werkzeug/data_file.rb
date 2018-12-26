require_relative 'error'

module Werkzeug
  DataFile = Class.new do

    def initialize
      @default = nil
    end

    def default
      @default ||= parse(defined?(::DATA) ? ::DATA : '').freeze
    end

    def names
      default.keys
    end

    def [](name)
      default[name]
    end

    def read(file_name = nil)
      file_name ||= caller_locations(1, 1)[0].path
      parse(File.read(file_name).split(RE_END, 2)[-1])
    end

    def parse(lines)
      lines.respond_to?(:each_line) || Error::MethodExpected.raise!(:each_line)
      ret, name, content = {}, :default, []
      lines.each_line do |line|
        next content << line unless line.start_with?('@@ '.freeze)
        ret[name] = content.join
        name, content = line.chomp[3..-1].to_sym, []
      end
      ret[name] = content.join
      ret
    end

    RE_END = /^__END__$\s*/.freeze
  end.new
end
