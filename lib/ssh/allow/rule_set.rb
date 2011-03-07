require 'singleton'

module SSH::Allow

  class RuleSet
    attr_reader :rules

    def initialize
      @rules = []
    end

    def allow(cmd, &block)
      push get_rule(cmd, block)
    end

    def allow!(cmd, &block)
      rule = get_rule(cmd, block)
      push(rule) or raise(%(Invalid rule: "#{cmd}"))
    end

    def read(path_to_rules)
      self.instance_eval(read_rules(path_to_rules))
    end

    private

      def push(rule)
        rule.valid? ? @rules.push(rule) : false
      end

      def get_rule(cmd, block)
        SSH::Allow::Rule.parse(cmd, block)
      end

      def read_rules(path_to_rules)
        IO.read(path_to_rules)
      end
  end

  class RuleSet::Single < RuleSet
    include Singleton
  end

end
