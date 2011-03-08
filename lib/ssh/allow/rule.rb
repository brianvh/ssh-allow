module SSH ; module Allow

  class Rule
    attr_reader :command

    def initialize(cmds)
      @command = [cmds].flatten
      @options = [:none]
      @arguments = [:none]
    end

    class << self
      def allow(*cmds, &block)
        create(Rule::Allow.new(cmds.flatten), &block)
      end

      def deny(*cmds, &block)
        create(Rule::Deny.new(cmds.flatten), &block)
      end

      def create(rule, &block)
        rule.instance_eval(&block) if block_given?
        rule
      end
    end

    class Allow < Rule
      
    end

    class Deny < Rule
      
    end
  end

end ; end
