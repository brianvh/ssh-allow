require 'singleton'

module SSH::Allow

  class Configuration
    attr_reader :rules, :error

    def initialize
      @rules = []
      @error = nil
    end

    def valid?
      error.nil?
    end

    def allow(cmd, &block)
      add_rule parse_command(cmd, block)
    end

    def allow!(cmd, &block)
      rule = parse_command(cmd, block)
      add_rule(rule) or raise(%(Invalid rule: "#{cmd}"))
    end

    def read(path_to_config)
      self.instance_eval(read_config(path_to_config))
    end

    def reset!
      @rules.clear
    end

    private

      def add_rule(rule)
        rule.valid? ? @rules.push(rule) : false
      end

      def parse_command(cmd, &block)
        SSH::Allow::Rule.parse(cmd, block)
      end

      def read_config(path_to_config)
        IO.read(path_to_config)
      end
  end

  class Configuration::Single < Configuration
    include Singleton
  end

end
