module SSH ; module Allow

  class Rule
    attr_reader :command, :options, :arguments

    def initialize(cmds)
      @command = [cmds].flatten
      @options = [:none]
      @arguments = [:none]
    end

    def opts(opt_text)
      push(:options, opt_text)
    end

    def args(arg_text)
      push(:arguments, arg_text)
    end

    def push(attrib, value)
      send(attrib).clear if send(attrib) == [:none]
      send(attrib).push(value)
    end
    private :push

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
      
    end

    class Deny < Rule
      
    end
  end

end ; end
