module SSH ; module Allow

  class RuleSet
    attr_reader :rules

    def initialize
      @rules = []
    end

    def allow(cmd, &block)
      push get_rule(:allow, cmd, block)
    end

    def allow!(cmd, &block)
      rule = get_rule(:allow, cmd, block)
      push(rule) or raise(%(Invalid rule: "#{cmd}"))
    end

    def read(path_to_rules)
      self.instance_eval(read_rules(path_to_rules))
    end

    private

    def push(rule)
      rule ? @rules.push(rule) : false
    end

    def get_rule(type, cmd, block)
      SSH::Allow::Rule.send(type, cmd, &block)
    end

    def read_rules(path_to_rules)
      IO.read(path_to_rules)
    end
  end

end ; end
