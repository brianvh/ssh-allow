module SSH ; module Allow

  class Rule
    attr_reader :command, :options, :arguments

    def initialize(cmds)
      @command = [cmds].flatten
      @options = [:none]
      @arguments = [:none]
    end

    def opts(opt_text)
      opt_text.gsub!(/^--?/, '') if opt_text.is_a?(String)
      push(:options, opt_text)
    end

    def args(arg_text)
      arg_text = Regexp.new(arg_text) if arg_text.is_a?(String)
      push(:arguments, arg_text)
    end

    def match_command?(name)
      return false if none?(command)
      return true if any?(command)
      command.include?(name)
    end

    def match_options?(opt_list)
      return opt_list.empty? if none?(options)
      return true if any?(options)
      return false if options.size != opt_list.size
      opt_list.inject(true) { |match, opt| match && options.include?(opt) }
    end

    def match_arguments?(arg_list)
      return arg_list.empty? if none?(arguments)
      return true if any?(arguments)
      return false if arguments.size != arg_list.size
      arg_list.inject(true) { |match, arg| match && match_one_argument?(arg) }
    end

    def match_one_argument?(arg)
      arguments.inject(false) { |match, one_arg| match || (one_arg === arg) }
    end

    def push(attrib, value)
      send(attrib).clear if send(attrib) == [:none]
      send(attrib).push(value)
    end

    def none?(part)
      part == [:none]
    end

    def any?(part)
      part == [:any]
    end

    private :push, :none?, :any?, :match_one_argument?

    class << self
      def allow(*cmds, &block)
        create(Rule::Allow.new(cmds.flatten), &block)
      end

      def deny(*cmds, &block)
        create(Rule::Deny.new(cmds.flatten), &block)
      end

      def create(rule, &block)
        begin
          rule.instance_eval(&block) if block_given?
          rule
        rescue Exception => e
          false
        end
      end
    end

    class Allow < Rule
      def match?(command)
        match = [match_command?(command.name), match_options?(command.options),
          match_arguments?(command.arguments)].inject(true) { |mem, var| var && mem }
        return match, match
      end
    end

    class Deny < Rule
      def match?(command)
        match = [match_command?(command.name), match_options?(command.options),
          match_arguments?(command.arguments)].inject(true) { |mem, var| var && mem }
        return match, !match
      end
    end
  end

end ; end
