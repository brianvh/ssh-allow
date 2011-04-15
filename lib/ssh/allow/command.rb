$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

require 'polyglot'
require 'treetop'
require 'command_line'

module SSH ; module Allow
  class Command
    attr_reader :name, :options, :arguments

    def initialize(cmd)
      @cmd = cmd.to_s
      @name = parsed.name.text_value
      @options = parsed.option_list
      @arguments = parsed.argument_list
    end

    def to_s
      @cmd
    end

    def run
      system(@cmd)
    end

    private

    def parsed
      @parsed ||= CommandLineParser.new.parse(@cmd)
    end
  end
end ; end
